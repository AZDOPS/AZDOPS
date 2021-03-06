Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot\..\Source\ADOPS -Force

Describe 'Get-ADOPSWiki' {
    BeforeAll {
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
            { Get-Command -Name Get-ADOPSWiki -Module ADOPS -ErrorAction Stop } | Should -Not -Throw
        }

        It "Contains non mandatory parameter: <_>" -TestCases 'Organization', 'WikiId' {
            Get-Command -Name Get-ADOPSWiki | Should -HaveParameter $_
        }

        It "Contains mandatory parameter: <_>" -TestCases 'Project' {
            Get-Command -Name Get-ADOPSWiki | Should -HaveParameter $_ -Mandatory
        }
    }

    Context "Functionality" {

        It 'Should get organization from GetADOPSHeader when organization parameter is used' {
            Get-ADOPSWiki -Organization 'anotherorg' -Project 'myproj' 
            Should -Invoke GetADOPSHeader -ModuleName ADOPS -ParameterFilter { $Organization -eq 'anotherorg' } -Times 1 -Exactly
        }

        It 'Should validate organization using GetADOPSHeader when organization parameter is not used' {
            Get-ADOPSWiki -Project 'myproj'
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

            $r = Get-ADOPSWiki -Project 'myproj'
            $r.name | Should -Be 'HasValue'
        }

        It 'If result does not have value member, it should be returned' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                [PSCustomObject]@{
                    name = "HasNoValue"
                }
            }
            $r = Get-ADOPSWiki -Project 'myproj'
            $r.name | Should -Be 'HasNoValue'
        }
        
        It 'Verifying URI, no WikiID given' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $URI
            }

            $r = Get-ADOPSWiki -Project 'myproj'
            $r | Should -Be 'https://dev.azure.com/myorg/myproj/_apis/wiki/wikis?api-version=7.1-preview.2'
        }

        It 'Verifying URI, WikiID given' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $URI
            }

            $r = Get-ADOPSWiki -Project 'myproj' -WikiId 'MyWiki'
            $r | Should -Be 'https://dev.azure.com/myorg/myproj/_apis/wiki/wikis/MyWiki?api-version=7.1-preview.2'
        }

        It 'Verifying method' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $Method
            }
            $r = Get-ADOPSWiki -Project 'myproj'
            $r | Should -Be 'Get'
        }
    }
}