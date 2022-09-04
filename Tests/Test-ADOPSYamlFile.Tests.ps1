BeforeDiscovery {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSScriptRoot\..\Source\ADOPS -Force
}

Describe 'Test-ADOPSYamlFile' {
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
                Name = 'File'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'PipelineId'
                Mandatory = $true
                Type = 'Int32'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command Test-ADOPSYamlFile | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
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

                Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                    $errorDetails =  '{"typeName": "Exception", "message": "Some Error."}'
                    $statusCode = 400
                    $response = New-Object System.Net.Http.HttpResponseMessage $statusCode
                    $exception = New-Object Microsoft.PowerShell.Commands.HttpResponseException "$statusCode ($($response.ReasonPhrase))", $response
                    $errorCategory = [System.Management.Automation.ErrorCategory]::InvalidOperation
                    $errorID = 'WebCmdletWebResponseException,Microsoft.PowerShell.Commands.InvokeWebRequestCommand'
                    $targetObject = $null
                    $errorRecord = New-Object Management.Automation.ErrorRecord $exception, $errorID, $errorCategory, $targetObject
                    $errorRecord.ErrorDetails = $errorDetails
                
                    Throw $errorRecord
                } -ParameterFilter { $method -eq 'post' -and $Uri -like '*/22/runs?*' }
            }

        }

        It 'Should get organization from GetADOPSHeader when organization parameter is used' {
            Test-ADOPSYamlFile -Project 'DummyProj' -File 'c:\DummyFile.yml' -PipelineId 666 -Organization 'DummyOrg'
            Should -Invoke GetADOPSHeader -ModuleName ADOPS -ParameterFilter { $Organization -eq 'DummyOrg' } -Times 1 -Exactly
        }

        It 'Should validate organization using GetADOPSHeader when organization parameter is not used' {
            Test-ADOPSYamlFile -Project 'DummyProj' -File 'c:\DummyFile.yml' -PipelineId 666
            Should -Invoke GetADOPSHeader -ModuleName ADOPS -ParameterFilter { $Organization -eq 'DummyOrg' } -Times 0 -Exactly
            Should -Invoke GetADOPSHeader -ModuleName ADOPS -Times 1 -Exactly
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

        It 'Should throw if yaml file is not valid' {
            {Test-ADOPSYamlFile -Project 'DummyProj' -File 'c:\DummyFile.yaml' -PipelineId 22} | Should -Throw -ExpectedMessage '400 (Bad Request)'
        }
    }
}
