param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
    
    Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'DummyOrg' }

    Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
        return $InvokeSplat
    } -ParameterFilter { $Method -eq 'Post' }

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

AfterAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
}

Describe 'Test-ADOPSYamlFile' {
    Context 'Parameters' {
        $TestCases = @(
            @{
                Name      = 'Organization'
                Mandatory = $false
                Type      = 'string'
            },
            @{
                Name      = 'Project'
                Mandatory = $true
                Type      = 'string'
            },
            @{
                Name      = 'File'
                Mandatory = $true
                Type      = 'string'
            },
            @{
                Name      = 'PipelineId'
                Mandatory = $true
                Type      = 'Int32'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases {
            Get-Command Test-ADOPSYamlFile | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }

    Context 'Verifying invoke body' {
        It 'Should call mocks' {
            $null = Test-ADOPSYamlFile -Project 'DummyProj' -File 'c:\DummyFile.yml' -PipelineId 666
            Should -Invoke -CommandName GetADOPSDefaultOrganization -Times 1 -Exactly -ModuleName ADOPS
            Should -Invoke -CommandName InvokeADOPSRestMethod -Times 1 -Exactly -ModuleName ADOPS
            Should -Invoke -CommandName Get-Content -Times 1 -Exactly -ModuleName ADOPS
        }
    }

    Context 'Functionality' {
        BeforeAll {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                $errorDetails = '{"typeName": "Exception", "message": "Some Error."}'
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

        It 'Should not get organization from GetADOPSDefaultOrganization when organization parameter is used' {
            Test-ADOPSYamlFile -Project 'DummyProj' -File 'c:\DummyFile.yml' -PipelineId 666 -Organization 'DummyOrg'
            Should -Invoke GetADOPSDefaultOrganization -ModuleName ADOPS -Times 0 -Exactly
        }

        It 'Should get organization using GetADOPSDefaultOrganization when organization parameter is not used' {
            Test-ADOPSYamlFile -Project 'DummyProj' -File 'c:\DummyFile.yml' -PipelineId 666
            Should -Invoke GetADOPSDefaultOrganization -ModuleName ADOPS -Times 1 -Exactly
        }

        It 'Should call mocks' {
            $null = Test-ADOPSYamlFile -Project 'DummyProj' -File 'c:\DummyFile.yml' -PipelineId 666
            Should -Invoke -CommandName GetADOPSDefaultOrganization -Times 1 -Exactly -ModuleName ADOPS
            Should -Invoke -CommandName InvokeADOPSRestMethod -Times 1 -Exactly -ModuleName ADOPS
            Should -Invoke -CommandName Get-Content -Times 1 -Exactly -ModuleName ADOPS
        }
        
        It 'Should throw if file is not of type .yaml or .yml' {
            { Test-ADOPSYamlFile -Project 'DummyProj' -File 'c:\DummyFile.bad' -PipelineId 666 } | Should -Throw
        }
        It 'Should NOT throw if file is of type .yaml' {
            { Test-ADOPSYamlFile -Project 'DummyProj' -File 'c:\DummyFile.yaml' -PipelineId 666 } | Should -Not -Throw
        }
        It 'Should NOT throw if file is of type .yml' {
            { Test-ADOPSYamlFile -Project 'DummyProj' -File 'c:\DummyFile.yml' -PipelineId 666 } | Should -Not -Throw
        }

        It 'Should throw if yaml file is not valid' {
            { Test-ADOPSYamlFile -Project 'DummyProj' -File 'c:\DummyFile.yaml' -PipelineId 22 } | Should -Throw -ExpectedMessage '400 (Bad Request)'
        }

        It 'Should handle normal yaml validation failures' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                $errorDetails = '{"typeName": "PipelineValidationException", "message": "Some Error."}'
                $statusCode = 400
                $response = New-Object System.Net.Http.HttpResponseMessage $statusCode
                $exception = New-Object Microsoft.PowerShell.Commands.HttpResponseException "$statusCode ($($response.ReasonPhrase))", $response
                $errorCategory = [System.Management.Automation.ErrorCategory]::InvalidOperation
                $errorID = 'WebCmdletWebResponseException,Microsoft.PowerShell.Commands.InvokeWebRequestCommand'
                $targetObject = $null
                $errorRecord = New-Object Management.Automation.ErrorRecord $exception, $errorID, $errorCategory, $targetObject
                $errorRecord.ErrorDetails = $errorDetails
            
                Throw $errorRecord
            } -ParameterFilter { $method -eq 'post' }

            Mock -CommandName Write-Warning -ModuleName ADOPS -MockWith {
                Write-Output @PesterBoundParameters
            }

            # When using @PesterBoundParameters like this mock does it kind of messes up the output. Use -join to solve it.
            -join (Test-ADOPSYamlFile -Project 'DummyProj' -File 'c:\DummyFile.yml' -PipelineId 666) | Should -BeLike '*Validation failed*'
        }
    }
}