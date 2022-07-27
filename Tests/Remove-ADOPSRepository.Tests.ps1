BeforeDiscovery {
    . $PSScriptRoot\TestHelpers.ps1
    Initialize-TestSetup
}

Describe 'Remove-ADOPSRepository' {
    BeforeAll {
        $RepositoryID = '72199bdd-39ff-4bea-a1ce-f0058e82c18c'

        Mock GetADOPSHeader -ModuleName ADOPS -MockWith {
            @{
                Organization = "myorg"
            }
        }
        Mock GetADOPSHeader -ModuleName ADOPS -ParameterFilter { $Organization -eq 'anotherorg' } -MockWith {
            @{
                Organization = "anotherOrg"
            }
        }

        Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {}
    }

    Context "General function tests" {
        It "Function exist" {
            { Get-Command -Name Remove-ADOPSRepository -Module ADOPS -ErrorAction Stop } | Should -Not -Throw
        }

        It "Contains non mandatory parameter: <_>" -TestCases 'Organization' {
            Get-Command -Name Remove-ADOPSRepository | Should -HaveParameter $_
        }

        It "Contains mandatory parameter: <_>" -TestCases 'Project', 'RepositoryID' {
            Get-Command -Name Remove-ADOPSRepository | Should -HaveParameter $_ -Mandatory
        }
    }

    Context "Functionality" {

        It 'Should get organization from GetADOPSHeader when organization parameter is used' {
            Remove-ADOPSRepository -Organization 'anotherorg' -Project 'myproj' -RepositoryID $RepositoryID
            Should -Invoke GetADOPSHeader -ModuleName ADOPS -ParameterFilter { $Organization -eq 'anotherorg' } -Times 1 -Exactly
        }

        It 'Should validate organization using GetADOPSHeader when organization parameter is not used' {
            Remove-ADOPSRepository -Project 'myproj' -RepositoryID $RepositoryID
            Should -Invoke GetADOPSHeader -ModuleName ADOPS -ParameterFilter { $Organization -eq 'anotherorg' } -Times 0 -Exactly
            Should -Invoke GetADOPSHeader -ModuleName ADOPS -Times 1 -Exactly
        }

        It 'If result has a value member, it should be returned' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                [PSCustomObject]@{
                    value = @(
                        @{
                            name = "HasValue"
                        }
                    )
                    count = 1
                }
            }

            $r = Remove-ADOPSRepository -Project 'myproj' -RepositoryID $RepositoryID
            $r.name | Should -Be 'HasValue'
        }

        It 'If result does not have value member, it should be returned' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                [PSCustomObject]@{
                    name = "HasNoValue"
                }
            }
            $r = Remove-ADOPSRepository -Project 'myproj' -RepositoryID $RepositoryID
            $r.name | Should -Be 'HasNoValue'
        }

        It 'Verifying URI' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $URI
            }

            $r = Remove-ADOPSRepository -Project 'myproj' -RepositoryID $RepositoryID
            $r | Should -Be "https://dev.azure.com/myorg/myproj/_apis/git/repositories/${RepositoryID}?api-version=7.1-preview.1"
        }

        It 'Verifying method' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $Method
            }
            $r = Remove-ADOPSRepository -Project 'myproj' -RepositoryID $RepositoryID
            $r | Should -Be 'Delete'
        }
    }
}