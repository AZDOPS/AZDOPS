param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'New-ADOPSEnvironment' {
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
            
            mock -CommandName 'Write-Output' -ModuleName ADOPS -MockWith {
                return $InvokeSplat
            }

            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return @{
                    project = @{
                        id = 1
                    }
                    id = 2
                }
            } -ParameterFilter {$Method -eq 'Post'}

            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
            } # default mock

            Mock -CommandName Get-ADOPSGroup -ModuleName ADOPS -MockWith {
                @(
                    @{
                        principalName = '[DummyProj]\Project Administrators'
                        originId = 'ProjAdmOriginId'
                    },
                    @{
                        principalName = 'AnotherGroup'
                        originId = 'AnotherGroupOriginId'
                    }
                )
            }
        }
    }

    Context 'Parameters' {
        $TestCases = @(
            @{
                Name = 'Organization'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'Project'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'Name'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'Description'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'AdminGroup'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'SkipAdmin'
                Mandatory = $false
                Type = 'switch'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command New-ADOPSEnvironment | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }

    Context "Functionality" {
        It 'If organization is given, in should call GetADOPSHeader with organization name' {
            $r = New-ADOPSEnvironment -Organization 'DummyOrg' -Project 'DummyProj' -Name 'EnvName'
            Should -Invoke -CommandName GetADOPSHeader -ModuleName ADOPS -ParameterFilter { $Organization }
        }
        It 'If organization is not given, in should call GetADOPSHeader with no parameters' {
            $r = New-ADOPSEnvironment -Project 'DummyProj' -Name 'EnvName'
            Should -Invoke -CommandName GetADOPSHeader -ModuleName ADOPS
        }
        
        It 'Creates correct URI' {
            $required = 'https://dev.azure.com/DummyOrg/DummyProj/_apis/distributedtask/environments?api-version=7.1-preview.1'
            $actual = New-ADOPSEnvironment -Project 'DummyProj' -Name 'EnvName' -Description 'EnvDescription'
            $actual.Uri | Should -Be $required
        }

        It 'Method sould be Post' {
            $required = 'Post'
            $actual = New-ADOPSEnvironment -Project 'DummyProj' -Name 'EnvName' -Description 'EnvDescription'
            $actual.Method | Should -Be $required
        }

        It 'Verifying body' {
            $required = '{"name":"EnvName","description":"Environment description"}'
            $actual = New-ADOPSEnvironment -Project 'DummyProj' -Name 'EnvName' -Description 'Environment description'
            $actual.Body | Should -Be $required
        }
    }

    Context 'Admin group settings' {
        BeforeAll {
            InModuleScope -ModuleName ADOPS {
                mock -CommandName Write-Output -ModuleName ADOPS -MockWith {
                    return $SecInvokeSplat
                }
            }
        }
        It 'If SkipAdmin is set do not add admin group' {
            $required = 'Skipped admin group'
            $actual = New-ADOPSEnvironment -Project 'DummyProj' -Name 'EnvName' -Description 'Environment description' -SkipAdmin -Verbose 4>&1
            $actual[1] | Should -Be $required
        }
        
        It 'Creates correct security URI' {
            $required = 'https://dev.azure.com/DummyOrg/_apis/securityroles/scopes/distributedtask.environmentreferencerole/roleassignments/resources/1_2?api-version=7.1-preview.1'
            $actual = New-ADOPSEnvironment -Project 'DummyProj' -Name 'EnvName' -Description 'EnvDescription'
            $actual.Uri | Should -Be $required
        }

        It 'security Method sould be Put' {
            $required = 'Put'
            $actual = New-ADOPSEnvironment -Project 'DummyProj' -Name 'EnvName' -Description 'EnvDescription'
            $actual.Method | Should -Be $required
        }

        It 'Verifying security body, no group given' {
            $required = '[{"userId":"ProjAdmOriginId","roleName":"Administrator"}]'
            $actual = New-ADOPSEnvironment -Project 'DummyProj' -Name 'EnvName' -Description 'Environment description'
            $actual.Body | Should -Be $required
        }

        It 'Verifying security body, custom group' {
            $required = '[{"userId":"AnotherGroupOriginId","roleName":"Administrator"}]'
            $actual = New-ADOPSEnvironment -Project 'DummyProj' -Name 'EnvName' -Description 'Environment description' -AdminGroup 'AnotherGroup'
            $actual.Body | Should -Be $required
        }
    }
}