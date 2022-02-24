Remove-Module AZDOPS -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot\..\Source\AZDOPS

InModuleScope -ModuleName AZDOPS {
    Describe 'Get-AZDOPSPipeline tests' {
        Context 'Getting Pipeline' {
            BeforeAll {

                $OrganizationName = 'DummyOrg'
                $Project = 'DummyProject'
                $PipeName = 'DummyPipe1'
                
                Mock -CommandName GetAZDOPSHeader -ModuleName AZDOPS -MockWith {
                    @{
                        Header       = @{
                            'Authorization' = 'Basic Base64=='
                        }
                        Organization = $OrganizationName
                    }
                } -ParameterFilter { $OrganizationName -eq $OrganizationName }
                Mock -CommandName GetAZDOPSHeader -ModuleName AZDOPS -MockWith {
                    @{
                        Header       = @{
                            'Authorization' = 'Basic Base64=='
                        }
                        Organization = $OrganizationName
                    }
                }

                Mock -CommandName InvokeAZDOPSRestMethod -ModuleName AZDOPS -MockWith {
                    return @'
                    {
                        "value": [
                            {
                                "_links": {
                                "self": "@{href=https://dev.azure.com/OrganizationName/Project/_apis/pipelines/10?revision=1}",
                                "web": "@{href=https://dev.azure.com/OrganizationName/Project/_build/definition?definitionId=10}"
                                },
                                "url": "https://dev.azure.com/OrganizationName/Project/_apis/pipelines/10?revision=1",
                                "id": 10,
                                "revision": 1,
                                "name": "DummyPipe1",
                                "folder": "\\"
                            },
                            {
                                "_links": {
                                "self": "@{href=https://dev.azure.com/OrganizationName/Project/_apis/pipelines/9?revision=1}",
                                "web": "@{href=https://dev.azure.com/OrganizationName/Project/_build/definition?definitionId=9}"
                                },
                                "url": "https://dev.azure.com/OrganizationName/Project/_apis/pipelines/9?revision=1",
                                "id": 9,
                                "revision": 1,
                                "name": "DummyPipe2",
                                "folder": "\\"
                            }
                        ]
                    }
'@ | ConvertFrom-Json
                } -ParameterFilter { $method -eq 'Get' }

            }
            It 'uses InvokeAZDOPSRestMethod two times' {
                Get-AZDOPSPipeline -Organization $OrganizationName -Project $Project -Name $PipeName
                Should -Invoke 'InvokeAZDOPSRestMethod' -ModuleName 'AZDOPS' -Exactly -Times 2
            }
            It 'returns output after getting pipeline' {
                Get-AZDOPSPipeline -Organization $OrganizationName -Project $Project -Name $PipeName | Should -BeOfType [pscustomobject] -Because 'InvokeAZDOPSRestMethod should convert the json to pscustomobject'
            }
            It 'should not throw with mandatory parameters' {
                { Get-AZDOPSPipeline -Organization $OrganizationName -Project $Project -Name $PipeName } | Should -Not -Throw
            }
            It 'returns single output after getting pipeline' {
                (Get-AZDOPSPipeline -Organization $OrganizationName -Project $Project -Name $PipeName).count | Should -Be 1
            }
            It 'returns multiple outputs after getting pipelines' {
                (Get-AZDOPSPipeline -Organization $OrganizationName -Project $Project).count | Should -Be 2
            }
        }

        Context 'Parameters' {
            It 'Should have parameter Organization' {
                (Get-Command Get-AZDOPSPipeline).Parameters.Keys | Should -Contain 'Organization'
            }
            It 'Organization should not be required' {
                (Get-Command Get-AZDOPSPipeline).Parameters['Organization'].Attributes.Mandatory | Should -Be $false
            }
            It 'Should have parameter Project' {
                (Get-Command Get-AZDOPSPipeline).Parameters.Keys | Should -Contain 'Project'
            }
            It 'Project should be required' {
                (Get-Command Get-AZDOPSPipeline).Parameters['Project'].Attributes.Mandatory | Should -Be $true
            }
            It 'Should have parameter Name' {
                (Get-Command Get-AZDOPSPipeline).Parameters.Keys | Should -Contain 'Name'
            }
            It 'Name should not be required' {
                (Get-Command Get-AZDOPSPipeline).Parameters['Name'].Attributes.Mandatory | Should -Be $false
            }
        }
    }
}