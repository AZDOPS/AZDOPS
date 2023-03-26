param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'Set-ADOPSGitPermission' {
    Context 'Parameters' {    
        $TestCases = @(
            @{
                Name = 'Organization'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'RepositoryId'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'ProjectId'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'Descriptor'
                Mandatory = $true
                Type = 'string'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command Set-ADOPSGitPermission | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }

    Context 'Custom typed Parameters' {    
        $TestCases = @(
            @{
                Name = 'Allow'
                Mandatory = $false
                Type = 'AccessLevels[]'
            },
            @{
                Name = 'Deny'
                Mandatory = $false
                Type = 'AccessLevels[]'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command Set-ADOPSGitPermission | Should -HaveParameter $_.Name -Mandatory:$_.mandatory
            (Get-Command Set-ADOPSGitPermission | Select-Object -ExpandProperty parameters)."$($_.Name)".ParameterType.Name | Should -Be $_.Type
        }
    }
    
    Context "Functionality" {
        BeforeAll {
            InModuleScope -ModuleName ADOPS {
                Mock -CommandName GetADOPSHeader -ModuleName ADOPS -MockWith {
                    @{
                        Header       = @{
                            'Authorization' = 'Basic Base64=='
                        }
                        Organization = $Organization
                    }
                } -ParameterFilter { $Organization }
                Mock -CommandName GetADOPSHeader -ModuleName ADOPS -MockWith {
                    @{
                        Header       = @{
                            'Authorization' = 'Basic Base64=='
                        }
                        Organization = 'DummyOrg'
                    }
                }
                
                Mock -CommandName InvokeADOPSRestMethod  -ModuleName ADOPS -MockWith {
                    return $InvokeSplat
                }
            }
        }

        It 'If organization is given, in should call GetADOPSHeader with organization name' {
            $s = @{
                ProjectId = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' 
                RepositoryId = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' 
                Descriptor = 'aad.AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' 
                Organization = 'DummyOrg'
                Allow = 'Administer'
            }
            $r = Set-ADOPSGitPermission @s
            Should -Invoke -CommandName GetADOPSHeader -ModuleName ADOPS -ParameterFilter { $Organization }
        }

        It 'If organization is not given, in should call GetADOPSHeader with no parameters' {
            $s = @{
                ProjectId = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' 
                RepositoryId = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' 
                Descriptor = 'aad.AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'
                Allow = 'Administer'
            }
            $r = Set-ADOPSGitPermission @s
            Should -Invoke -CommandName GetADOPSHeader -ModuleName ADOPS
        }

        It 'If neither allow or deny is set, it should not do anything' {
            $s = @{
                ProjectId = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' 
                RepositoryId = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' 
                Descriptor = 'aad.AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'
            }
            Set-ADOPSGitPermission @s | Should -BeNullOrEmpty
        }

        It 'Should throw if user descriptor is not formated like a descriptor, to short' {
            {Set-ADOPSGitPermission -Allow Administer -Descriptor 'aad.NotADescriptorLength' -ProjectId 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' -RepositoryId '11111111-1111-1111-1111-111111111111'} | Should -Throw
        }

        It 'Should throw if Group descriptor is not formated like a descriptor, to short' {
            {Set-ADOPSGitPermission -Allow Administer -Descriptor 'aadgp.NotADescriptorLength' -ProjectId 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' -RepositoryId '11111111-1111-1111-1111-111111111111'} | Should -Throw
        }

        It 'Should throw if user descriptor is not formated like a descriptor, no first three letters' {
            {Set-ADOPSGitPermission -Allow Administer -Descriptor 'NotADescriptor' -ProjectId 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' -RepositoryId '11111111-1111-1111-1111-111111111111'} | Should -Throw
        }

        It 'Should throw if projectID is not in correct format' {
            {Set-ADOPSGitPermission -Allow Administer -Descriptor 'aad.AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' -ProjectId 'projectId' -RepositoryId '11111111-1111-1111-1111-111111111111'} | Should -Throw
        }

        It 'Verifying tokenPath' {
            $Expected = 'repov2/aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/11111111-1111-1111-1111-111111111111'
            $s = @{
                ProjectId = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' 
                RepositoryId = '11111111-1111-1111-1111-111111111111' 
                Descriptor = 'aad.AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'
                Allow = 'Administer'
            }
            $r = Set-ADOPSGitPermission @s
            ($r.Body | ConvertFrom-Json).token | Should -Be $Expected
        }

        It 'Verifying SubjectDescriptor' {
            InModuleScope -ModuleName ADOPS {
                Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                    @{
                        value = @{
                            descriptor = 'Microsoft.IdentityModel.Claims.ClaimsIdentity;aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa\user@domain.onmicrosoft.com'
                        }
                    }
                } -ParameterFilter {$Uri -like "*?subjectDescriptors*"}
            }

            $Expected = 'Microsoft.IdentityModel.Claims.ClaimsIdentity;aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa\user@domain.onmicrosoft.com'
            $s = @{
                ProjectId = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' 
                RepositoryId = '11111111-1111-1111-1111-111111111111' 
                Descriptor = 'aad.AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'
                Allow = 'Administer'
            }
            $r = Set-ADOPSGitPermission @s
            ($r.Body | ConvertFrom-Json).accessControlEntries.descriptor | Should -Be $Expected
        }

        It 'Set allow to the expected int value, no input' {
            $Expected = 0
            $s = @{
                ProjectId = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' 
                RepositoryId = '11111111-1111-1111-1111-111111111111' 
                Descriptor = 'aad.AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'
                Deny = 'Administer'
            }
            $r = Set-ADOPSGitPermission @s
            ($r.Body | ConvertFrom-Json).accessControlEntries.allow | Should -Be $Expected
        }

        It 'Set deny to the expected int value, no input' {
            $Expected = 0
            $s = @{
                ProjectId = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' 
                RepositoryId = '11111111-1111-1111-1111-111111111111' 
                Descriptor = 'aad.AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'
                Allow = 'Administer'
            }
            $r = Set-ADOPSGitPermission @s
            ($r.Body | ConvertFrom-Json).accessControlEntries.deny | Should -Be $Expected
        }

        It 'Set allow to the expected int value, one input' {
            $Expected = 256
            $s = @{
                ProjectId = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' 
                RepositoryId = '11111111-1111-1111-1111-111111111111' 
                Descriptor = 'aad.AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'
                Allow = 'CreateRepository'
            }
            $r = Set-ADOPSGitPermission @s
            ($r.Body | ConvertFrom-Json).accessControlEntries.allow | Should -Be $Expected
        }

        It 'Set deny to the expected int value, one input' {
            $Expected = 256
            $s = @{
                ProjectId = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' 
                RepositoryId = '11111111-1111-1111-1111-111111111111' 
                Descriptor = 'aad.AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'
                Deny = 'CreateRepository'
            }
            $r = Set-ADOPSGitPermission @s
            ($r.Body | ConvertFrom-Json).accessControlEntries.deny | Should -Be $Expected
        }

        It 'Set allow to the expected int value, multiple inputs' {
            $Expected = 1032
            $s = @{
                ProjectId = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' 
                RepositoryId = '11111111-1111-1111-1111-111111111111' 
                Descriptor = 'aad.AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'
                Allow = 'RenameRepository','ForcePush'
            }
            $r = Set-ADOPSGitPermission @s
            ($r.Body | ConvertFrom-Json).accessControlEntries.allow | Should -Be $Expected
        }

        It 'Set deny to the expected int value, multiple inputs' {
            $Expected = 1032
            $s = @{
                ProjectId = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' 
                RepositoryId = '11111111-1111-1111-1111-111111111111' 
                Descriptor = 'aad.AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'
                Deny = 'RenameRepository','ForcePush'
            }
            $r = Set-ADOPSGitPermission @s
            ($r.Body | ConvertFrom-Json).accessControlEntries.deny | Should -Be $Expected
        }

        It 'Verifying body' {
            InModuleScope -ModuleName ADOPS {
                Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                    @{
                        value = @{
                            descriptor = 'Microsoft.IdentityModel.Claims.ClaimsIdentity;aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa\user@domain.onmicrosoft.com'
                        }
                    }
                } -ParameterFilter {$Uri -like "*?subjectDescriptors*"}
            }

            $Expected = '{"token":"repov2/aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/11111111-1111-1111-1111-111111111111","merge":true,"accessControlEntries":[{"allow":1,"deny":0,"descriptor":"Microsoft.IdentityModel.Claims.ClaimsIdentity;aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa\\user@domain.onmicrosoft.com"}]}'
            $s = @{
                ProjectId = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' 
                RepositoryId = '11111111-1111-1111-1111-111111111111' 
                Descriptor = 'aad.AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'
                Allow = 'Administer'
            }
            $r = Set-ADOPSGitPermission @s
            $r.Body | Should -Be $Expected
        }
    }
}
