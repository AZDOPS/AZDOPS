param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'Set-ADOPSProject' {
    Context 'Parameters' {
        $TestCases = @(
            @{
                Name = 'Organization'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'ProjectName'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'ProjectId'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'Description'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'Visibility'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'Wait'
                Mandatory = $false
                Type = 'switch'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command Set-ADOPSProject | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }

    Context 'Updating project' {
        BeforeAll {
            Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'myorg' }

            Mock -CommandName Get-ADOPSProject -ModuleName ADOPS -MockWith {
                return @{
                    id = '0000000a-0a0a-0a0a-0a0a-0aaa0a00000a'
                }   
            }

            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith { }

            $Project = 'DummyProj'
        }

        It 'If neither description or visibility is set, exit early' {
            Set-ADOPSProject -ProjectName $Project

            Should -Invoke 'InvokeADOPSRestMethod' -ModuleName 'ADOPS' -Exactly -Times 0
            Should -Invoke 'GetADOPSDefaultOrganization' -ModuleName 'ADOPS' -Exactly -Times 0
            Should -Invoke 'Get-ADOPSProject' -ModuleName 'ADOPS' -Exactly -Times 0
        }

        It 'uses InvokeADOPSRestMethod one time' {
            Set-ADOPSProject -ProjectName $Project -Description 'New Description'

            Should -Invoke 'GetADOPSDefaultOrganization' -ModuleName 'ADOPS' -Exactly -Times 1
        }

        It 'Given a value to update it should invoke InvokeADOPSRestMethod one time'{
            Set-ADOPSProject -ProjectName $Project -Description 'New Description'

            Should -Invoke 'InvokeADOPSRestMethod' -ModuleName 'ADOPS' -Exactly -Times 1
        }
        
        It 'If ProjectName is given it should invoke Get-ADOPSProject one time'{
            Set-ADOPSProject -ProjectName $Project -Description 'New Description'

            Should -Invoke 'Get-ADOPSProject' -ModuleName 'ADOPS' -Exactly -Times 1
        }

        It 'Creates correct URI' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $Uri
            }
            $required = 'https://dev.azure.com/myorg/_apis/projects/0000000a-0a0a-0a0a-0a0a-0aaa0a00000a?api-version=7.2-preview.4'
            $actual = Set-ADOPSProject -ProjectName $Project -Description 'New Description'
            $actual | Should -Be $required
        }

        It 'Creates correct body, All parameters' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $Body
            }
            $required = '{"description":"New Description","visibility":"private"}'
            $actual = Set-ADOPSProject -ProjectName $Project -Description 'New Description' -Visibility 'Private'
            $actual | Should -Be $required
        }

        It 'Creates correct body, Only description' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $Body
            }
            $required = '{"description":"New Description"}'
            $actual = Set-ADOPSProject -ProjectName $Project -Description 'New Description'
            $actual | Should -Be $required
        }

        It 'Creates correct body, Only visibility' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $Body
            }
            $required = '{"visibility":"private"}'
            $actual = Set-ADOPSProject -ProjectName $Project -Visibility 'Private'
            $actual | Should -Be $required
        }

        It 'If wait is given, wait until status is not notSet' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                [PSCustomObject]@{
                    "id" = "0000000a-0a0a-0a0a-0a0a-0aaa0a00000a"
                    "status" = "notSet"
                    "url" = "https://dev.azure.com/myorg/_apis/operations/0000000a-0a0a-0a0a-0a0a-0aaa0a00000a"
                }
            } -ParameterFilter { $Method -eq 'Patch' }

            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                [PSCustomObject]@{
                    id = "0000000a-0a0a-0a0a-0a0a-0aaa0a00000a"
                    status = "succeeded"
                    url = "https://dev.azure.com/myorg/_apis/operations/0000000a-0a0a-0a0a-0a0a-0aaa0a00000a"
                }
            } -ParameterFilter { $Method -eq 'Get' -and $Uri -eq 'https://dev.azure.com/myorg/_apis/operations/0000000a-0a0a-0a0a-0a0a-0aaa0a00000a'}

            $required = 'succeeded'
            $actual = Set-ADOPSProject -ProjectName $Project -Visibility 'Private' -Wait
            $actual.status | Should -Be $required
        }
    }
}
