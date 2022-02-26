Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot\..\Source\ADOPS -Force

Describe "Get-ADOPSRepository" {
    Context "Function tests" {
        It "Function exists" {
            { Get-Command -Name Get-ADOPSRepository -Module ADOPS -ErrorAction Stop } | Should -Not -Throw
        }

        It 'Has parameter <_>' -TestCases 'Organization', 'Project', 'Repository' {
            (Get-Command -Name Get-ADOPSRepository).Parameters.Keys | Should -Contain $_
        }
    }

    Context "Function returns repositories" {
        BeforeAll {
            Mock InvokeADOPSRestMethod -ModuleName ADOPS {
                [PSCustomObject]@{
                    Value = @(
                        @{
                            Id = "84eba821-52d5-4ba8-a50b-63640ce234b8"
                        },
                        @{
                            Id = "250c42f9-f55e-4c64-a11c-d0d83a4f7fcc"
                        }
                    )
                }
            }
            Mock -CommandName GetADOPSHeader -ModuleName ADOPS -MockWith {
                @{
                    Header       = @{
                        'Authorization' = 'Basic Base64=='
                    }
                    Organization = 'DummyOrg'
                }
            } -ParameterFilter { $Organization -eq 'Organization' }
            Mock -CommandName GetADOPSHeader -ModuleName ADOPS -MockWith {
                @{
                    Header       = @{
                        'Authorization' = 'Basic Base64=='
                    }
                    Organization = 'DummyOrg'
                }
            }
        }

        It "Returns repositories" {
            Get-ADOPSRepository -Organization 'MyOrg' -Project 'MyProject' | Should -Not -BeNullOrEmpty
        }

        It "Returns repositories without organization specified" {
            Get-ADOPSRepository -Project 'MyProject' | Should -Not -BeNullOrEmpty
        }

        It 'Returns an id' {
            (Get-ADOPSRepository -Organization 'MyOrg' -Project 'MyProject').id | Should -Contain '84eba821-52d5-4ba8-a50b-63640ce234b8'
        }

        It 'Calls InvokeADOPSRestMethod with correct parameters when repository is used' {
            Get-ADOPSRepository -Organization 'MyOrg' -Project 'MyProject' -Repository 'MyRepo'
            Should -Invoke InvokeADOPSRestMethod -ModuleName ADOPS -Times 1 -Exactly -ParameterFilter {$Uri -eq 'https://dev.azure.com/MyOrg/MyProject/_apis/git/repositories/MyRepo?api-version=7.1-preview.1'}
        }

        It 'Can handle single repository responses from API' {
            Mock InvokeADOPSRestMethod -ModuleName ADOPS {
                [PSCustomObject]@{
                    Name = 'Fisar'
                }
            }
            
            (Get-ADOPSRepository -Organization 'MyOrg' -Project 'MyProject' -Repository 'MyRepo').Name | Should -Be 'Fisar'
        }
    }
}