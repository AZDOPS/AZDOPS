Remove-Module ADOPS -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot\..\Source\ADOPS

InModuleScope -ModuleName ADOPS {
    Describe 'Get-ADOPSProject tests' {
        Context 'Get project' {
            BeforeAll {
                Mock -CommandName GetADOPSHeader -ModuleName ADOPS -MockWith {
                    @{
                        Header       = @{
                            'Authorization' = 'Basic Base64=='
                        }
                        Organization = $OrganizationName
                    }
                } -ParameterFilter { $OrganizationName -eq 'Organization' }
                Mock -CommandName GetADOPSHeader -ModuleName ADOPS -MockWith {
                    @{
                        Header       = @{
                            'Authorization' = 'Basic Base64=='
                        }
                        Organization = $OrganizationName
                    }
                }

                Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                    return @'
                    {
                        "value": [
                            {
                                "id": "34f7babc-b656-4d13-bf24-bba1782d88fe",
                                "name": "DummyProject",
                                "description": "DummyProject",
                                "url": "https://dev.azure.com/DummyOrg/_apis/projects/34f7babc-b656-4d13-bf24-bba1782d88fe",
                                "state": "wellFormed",
                                "revision": 1,
                                "visibility": "private",
                            }
                        ]
                    }
'@ | ConvertFrom-Json
                } -ParameterFilter { $method -eq 'GET' }

                $OrganizationName = 'DummyOrg'
                $Project = 'DummyProject'
            }

            It 'uses InvokeADOPSRestMethod one time.' {
                Get-ADOPSProject -Organization $OrganizationName -Project $Project 
                Should -Invoke 'InvokeADOPSRestMethod' -ModuleName 'ADOPS' -Exactly -Times 1
            }
            It 'returns output after getting project' {
                Get-ADOPSProject -Organization $OrganizationName -Project $Project | Should -BeOfType [pscustomobject] -Because 'InvokeADOPSRestMethod should convert the json to pscustomobject'
            }
            It 'should not throw with no parameters' {
                { Get-ADOPSProject } | Should -Not -Throw
            }
        }

        Context 'Parameters' {
            It 'Should have parameter Organization' {
                (Get-Command Get-ADOPSProject).Parameters.Keys | Should -Contain 'Organization'
            }
            It 'Organization should not be required' {
                (Get-Command Get-ADOPSProject).Parameters['Organization'].Attributes.Mandatory | Should -Be $false
            }
            It 'Should have parameter Project' {
                (Get-Command Get-ADOPSProject).Parameters.Keys | Should -Contain 'Project'
            }
            It 'Project not should be required' {
                (Get-Command Get-ADOPSProject).Parameters['Project'].Attributes.Mandatory | Should -Be $false
            }
        }
    }
}