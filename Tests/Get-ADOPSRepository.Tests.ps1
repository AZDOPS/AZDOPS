param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe "Get-ADOPSRepository" {
    Context "Parameters" {
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
                Name = 'Repository'
                Mandatory = $false
                Type = 'string'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command Get-ADOPSRepository | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
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
            Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'DummyOrg' }
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