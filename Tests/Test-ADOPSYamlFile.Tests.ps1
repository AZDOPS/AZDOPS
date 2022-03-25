Remove-Module ADOPS -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot\..\Source\ADOPS

Describe 'Test-ADOPSYamlFile' {
    Context 'Parameters' {
        It 'Should have parameter Name' {
            (Get-Command Test-ADOPSYamlFile).Parameters.Keys | Should -Contain 'Organization'
        }
        
        It 'Should have parameter Project' {
            (Get-Command Test-ADOPSYamlFile).Parameters.Keys | Should -Contain 'Project'
        }
        It 'Project should be mandatory' {
            (Get-Command Test-ADOPSYamlFile).Parameters['Project'].Attributes.Mandatory | Should -Be $true
        }

        It 'Should have parameter File' {
            (Get-Command Test-ADOPSYamlFile).Parameters.Keys | Should -Contain 'File'
        }
        It 'File should be mandatory' {
            (Get-Command Test-ADOPSYamlFile).Parameters['File'].Attributes.Mandatory | Should -Be $true
        }
        
        It 'Should have parameter PipelineId' {
            (Get-Command Test-ADOPSYamlFile).Parameters.Keys | Should -Contain 'PipelineId'
        }
        It 'PipelineId should be mandatory' {
            (Get-Command Test-ADOPSYamlFile).Parameters['PipelineId'].Attributes.Mandatory | Should -Be $true
        }
    }

    Context 'Verifying invoke body' {
        BeforeAll {
            InModuleScope -ModuleName ADOPS {
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

                Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                    return $InvokeSplat
                } -ParameterFilter { $method -eq 'post' }

                Mock -CommandName Get-Content -ModuleName ADOPS -MockWith {
                    return @'
pool:
vmImage: 'windows-latest'

steps:
- task: PowerShell@2
displayName: 'TestRunner for Graph modules'
inputs:
filePath: .\TestRunner.ps1
pwsh: true

- task: PublishTestResults@2
inputs:
testResultsFormat: NUnit
testResultsFiles: |
    **\test*.xml
failTaskOnFailedTests: false          
'@
                }
            }

        }

        It 'Should call mocks' {
            $null = Test-ADOPSYamlFile -Project 'DummyProj' -File 'c:\DummyFile.yml' -PipelineId 666
            Should -Invoke -CommandName GetADOPSHeader -Times 1 -Exactly -ModuleName ADOPS
            Should -Invoke -CommandName InvokeADOPSRestMethod -Times 1 -Exactly -ModuleName ADOPS
            Should -Invoke -CommandName Get-Content -Times 1 -Exactly -ModuleName ADOPS
        }

        It 'Verify invoke object - Uri' {
            $r = Test-ADOPSYamlFile -Project 'DummyProj' -File 'c:\DummyFile.yml' -PipelineId 666
            $r.Uri | Should -Be 'https://dev.azure.com/DummyOrg/DummyProj/_apis/pipelines/666/runs?api-version=7.1-preview.1'
        }
        It 'Verify invoke object - Method' {
            $r = Test-ADOPSYamlFile -Project 'DummyProj' -File 'c:\DummyFile.yml' -PipelineId 666
            $r.Method | Should -Be 'Post'
        }
        It 'Verify invoke object - Body - previewRun' {
            $r = (Test-ADOPSYamlFile -Project 'DummyProj' -File 'c:\DummyFile.yml' -PipelineId 666).Body | ConvertFrom-Json
            $r.previewRun | Should -Be $true
        }
        It 'Verify invoke object - Body - templateParameters' {
            $r = (Test-ADOPSYamlFile -Project 'DummyProj' -File 'c:\DummyFile.yml' -PipelineId 666).Body | ConvertFrom-Json
            $r.templateParameters | Should -BeNullOrEmpty
        }
        It 'Verify invoke object - Body - resources' {
            $r = (Test-ADOPSYamlFile -Project 'DummyProj' -File 'c:\DummyFile.yml' -PipelineId 666).Body | ConvertFrom-Json
            $r.resources | Should -BeNullOrEmpty
        }
        It 'Verify invoke object - Body - yamlOverride' {
            $r = (Test-ADOPSYamlFile -Project 'DummyProj' -File 'c:\DummyFile.yml' -PipelineId 666).Body | ConvertFrom-Json
            $r.yamlOverride | Should -Not -BeNullOrEmpty
        }
    }

    Context 'Functionality' {
        BeforeAll {
            InModuleScope -ModuleName ADOPS {
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

                Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                    return $InvokeSplat
                } -ParameterFilter { $method -eq 'post' }

                Mock -CommandName Get-Content -ModuleName ADOPS -MockWith {
                    return @'
pool:
vmImage: 'windows-latest'

steps:
- task: PowerShell@2
displayName: 'TestRunner for Graph modules'
inputs:
filePath: .\TestRunner.ps1
pwsh: true

- task: PublishTestResults@2
inputs:
testResultsFormat: NUnit
testResultsFiles: |
    **\test*.xml
failTaskOnFailedTests: false          
'@
                }
            }

        }

        It 'Should call mocks' {
            $null = Test-ADOPSYamlFile -Project 'DummyProj' -File 'c:\DummyFile.yml' -PipelineId 666
            Should -Invoke -CommandName GetADOPSHeader -Times 1 -Exactly -ModuleName ADOPS
            Should -Invoke -CommandName InvokeADOPSRestMethod -Times 1 -Exactly -ModuleName ADOPS
            Should -Invoke -CommandName Get-Content -Times 1 -Exactly -ModuleName ADOPS
        }
        
        It 'Should throw if file is not of type .yaml or .yml' {
            {Test-ADOPSYamlFile -Project 'DummyProj' -File 'c:\DummyFile.bad' -PipelineId 666} | Should -Throw
        }
        It 'Should NOT throw if file is of type .yaml' {
            {Test-ADOPSYamlFile -Project 'DummyProj' -File 'c:\DummyFile.yaml' -PipelineId 666} | Should -not -Throw
        }
        It 'Should NOT throw if file is of type .yml' {
            {Test-ADOPSYamlFile -Project 'DummyProj' -File 'c:\DummyFile.yml' -PipelineId 666} | Should -not -Throw
        }

        #TODO: How to test error handling with HTTP response?
    }
}
