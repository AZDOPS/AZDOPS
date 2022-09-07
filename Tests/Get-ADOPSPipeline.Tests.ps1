param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'Get-ADOPSPipeline' {
    Context 'Parameters' {
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
                Name = 'name'
                Mandatory = $false
                Type = 'string'
            }
        )

        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command Get-ADOPSPipeline | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }
    
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
        It 'should not throw without Organization parameter' {
            { Get-ADOPSPipeline -Project $Project -Name $PipeName } | Should -Not -Throw
        }
        It 'should throw if pipeline name does not exist' {
            { Get-ADOPSPipeline -Project $Project -Name 'MissingPipeline' } | Should -Throw
        }
        It 'returns single output after getting pipeline' {
            (Get-ADOPSPipeline -Organization $OrganizationName -Project $Project -Name $PipeName).count | Should -Be 1
        }
        It 'returns multiple outputs after getting pipelines' {
            (Get-ADOPSPipeline -Organization $OrganizationName -Project $Project).count | Should -Be 2
        }
    }
}
