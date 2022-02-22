Remove-Module AZDevOPS -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot\..\Source\AZDevOPS

Describe "Get-AZDevOPSRepository" {
    Context "Function tests" {
        It "Function exists" {
            { Get-Command -Name Get-AZDevOPSRepository -Module AZDevOPS -ErrorAction Stop } | Should -Not -Throw
        }

        It 'Has parameter <_>' -TestCases 'Organization', 'Project', 'Repository' {
            (Get-Command -Name Get-AZDevOPSRepository).Parameters.Keys | Should -Contain $_
        }
    }

    Context "Function returns repositories" {
        BeforeAll {
            Mock InvokeAZDevOPSRestMethod -ModuleName AZDevOPS {
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
        }

        It "Returns repositories" {
            Get-AZDevOPSRepository -Organization 'MyOrg' -Project 'MyProject' | Should -Not -BeNullOrEmpty
        }

        It 'Returns an id' {
            (Get-AZDevOPSRepository -Organization 'MyOrg' -Project 'MyProject').id | Should -Contain '84eba821-52d5-4ba8-a50b-63640ce234b8'
        }

        It 'Calls InvokeAZDevOPSRestMethod with correct parameters when repository is used' {
            Get-AZDevOPSRepository -Organization 'MyOrg' -Project 'MyProject' -Repository 'MyRepo'
            Should -Invoke InvokeAZDevOPSRestMethod -ModuleName AZDevOPS -Times 1 -Exactly -ParameterFilter {$Uri -eq 'https://dev.azure.com/MyOrg/MyProject/_apis/git/repositories/MyRepo?api-version=7.1-preview.1'}
        }

        It 'Can handle single repository responses from API' {
            Mock InvokeAZDevOPSRestMethod -ModuleName AZDevOPS {
                [PSCustomObject]@{
                    Name = 'Fisar'
                }
            }
            
            (Get-AZDevOPSRepository -Organization 'MyOrg' -Project 'MyProject' -Repository 'MyRepo').Name | Should -Be 'Fisar'
        }
    }
}