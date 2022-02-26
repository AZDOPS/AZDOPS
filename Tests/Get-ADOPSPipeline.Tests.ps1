Remove-Module ADOPS -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot\..\Source\ADOPS

InModuleScope -ModuleName ADOPS {
    Describe 'Get-ADOPSPipeline tests' {
        Context 'Getting Pipeline' {
            BeforeAll {

                $OrganizationName = 'DummyOrg'
                $Project = 'DummyProject'
                $PipeName = 'DummyPipe1'
                
                Mock -CommandName GetADOPSHeader -ModuleName ADOPS -MockWith {
                    @{
                        Header       = @{
                            'Authorization' = 'Basic Base64=='
                        }
                        Organization = $OrganizationName
                    }
                } -ParameterFilter { $OrganizationName -eq $OrganizationName }
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
                } -ParameterFilter { $Method -eq 'Get' -and $Uri -like '*/pipelines?*' }

                Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                    return @'
                    {
                        "_links": {
                            "self": "@{href=https://dev.azure.com/OrganizationName/Project/_apis/pipelines/9?revision=1}",
                            "web": "@{href=https://dev.azure.com/OrganizationName/Project/_build/definition?definitionId=9}"
                        },
                        "configuration": {
                            "path": "DummyPipe1Path.yml",
                            "repository": "@{id=Repo; type=azureReposGit}",
                            "type": "yaml"
                        },
                        "url": "https://dev.azure.com/OrganizationName/Project/_apis/pipelines/9?revision=1",
                        "id": 9,
                        "revision": 1,
                        "name": "DummyPipe1",
                        "folder": "\\"
                    }
'@ | ConvertFrom-Json
                } -ParameterFilter { $Method -eq 'Get' -and $Uri -like '*/pipelines/*' }

            }
            It 'uses InvokeADOPSRestMethod two times' {
                Get-ADOPSPipeline -Organization $OrganizationName -Project $Project -Name $PipeName
                Should -Invoke 'InvokeADOPSRestMethod' -ModuleName 'ADOPS' -Exactly -Times 2
            }
            It 'returns output after getting pipeline' {
                Get-ADOPSPipeline -Organization $OrganizationName -Project $Project -Name $PipeName | Should -BeOfType [pscustomobject] -Because 'InvokeADOPSRestMethod should convert the json to pscustomobject'
            }
            It 'should not throw with mandatory parameters' {
                { Get-ADOPSPipeline -Organization $OrganizationName -Project $Project -Name $PipeName } | Should -Not -Throw
            }
            It 'returns single output after getting pipeline' {
                (Get-ADOPSPipeline -Organization $OrganizationName -Project $Project -Name $PipeName).count | Should -Be 1
            }
            It 'returns multiple outputs after getting pipelines' {
                (Get-ADOPSPipeline -Organization $OrganizationName -Project $Project).count | Should -Be 2
            }
        }

        Context 'Parameters' {
            It 'Should have parameter Organization' {
                (Get-Command Get-ADOPSPipeline).Parameters.Keys | Should -Contain 'Organization'
            }
            It 'Organization should not be required' {
                (Get-Command Get-ADOPSPipeline).Parameters['Organization'].Attributes.Mandatory | Should -Be $false
            }
            It 'Should have parameter Project' {
                (Get-Command Get-ADOPSPipeline).Parameters.Keys | Should -Contain 'Project'
            }
            It 'Project should be required' {
                (Get-Command Get-ADOPSPipeline).Parameters['Project'].Attributes.Mandatory | Should -Be $true
            }
            It 'Should have parameter Name' {
                (Get-Command Get-ADOPSPipeline).Parameters.Keys | Should -Contain 'Name'
            }
            It 'Name should not be required' {
                (Get-Command Get-ADOPSPipeline).Parameters['Name'].Attributes.Mandatory | Should -Be $false
            }
        }
    }
}