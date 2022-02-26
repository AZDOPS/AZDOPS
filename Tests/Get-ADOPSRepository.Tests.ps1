Remove-Module AZDOPS -Force -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot\..\Source\AZDOPS -Force

Describe "Get-AZDOPSRepository" {
    Context "Function tests" {
        It "Function exists" {
            { Get-Command -Name Get-AZDOPSRepository -Module AZDOPS -ErrorAction Stop } | Should -Not -Throw
        }

        It 'Has parameter <_>' -TestCases 'Organization', 'Project', 'Repository' {
            (Get-Command -Name Get-AZDOPSRepository).Parameters.Keys | Should -Contain $_
        }
    }

    Context "Function returns repositories" {
        BeforeAll {
            Mock InvokeAZDOPSRestMethod -ModuleName AZDOPS {
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
            Mock -CommandName GetAZDOPSHeader -ModuleName AZDOPS -MockWith {
                @{
                    Header       = @{
                        'Authorization' = 'Basic Base64=='
                    }
                    Organization = 'DummyOrg'
                }
            } -ParameterFilter { $Organization -eq 'Organization' }
            Mock -CommandName GetAZDOPSHeader -ModuleName AZDOPS -MockWith {
                @{
                    Header       = @{
                        'Authorization' = 'Basic Base64=='
                    }
                    Organization = 'DummyOrg'
                }
            }
        }

        It "Returns repositories" {
            Get-AZDOPSRepository -Organization 'MyOrg' -Project 'MyProject' | Should -Not -BeNullOrEmpty
        }

        It "Returns repositories without organization specified" {
            Get-AZDOPSRepository -Project 'MyProject' | Should -Not -BeNullOrEmpty
        }

        It 'Returns an id' {
            (Get-AZDOPSRepository -Organization 'MyOrg' -Project 'MyProject').id | Should -Contain '84eba821-52d5-4ba8-a50b-63640ce234b8'
        }

        It 'Calls InvokeAZDOPSRestMethod with correct parameters when repository is used' {
            Get-AZDOPSRepository -Organization 'MyOrg' -Project 'MyProject' -Repository 'MyRepo'
            Should -Invoke InvokeAZDOPSRestMethod -ModuleName AZDOPS -Times 1 -Exactly -ParameterFilter {$Uri -eq 'https://dev.azure.com/MyOrg/MyProject/_apis/git/repositories/MyRepo?api-version=7.1-preview.1'}
        }

        It 'Can handle single repository responses from API' {
            Mock InvokeAZDOPSRestMethod -ModuleName AZDOPS {
                [PSCustomObject]@{
                    Name = 'Fisar'
                }
            }
            
            (Get-AZDOPSRepository -Organization 'MyOrg' -Project 'MyProject' -Repository 'MyRepo').Name | Should -Be 'Fisar'
        }
    }
}