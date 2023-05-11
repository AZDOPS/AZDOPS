param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'Save-ADOPSPipelineTask' {
    Context 'Parameters' {
        $TestCases = @(
            @{
                Name      = 'Organization'
                Mandatory = $false
                Type      = 'string'
            },
            @{
                Name      = 'Path'
                Mandatory = $false
                Type      = 'string'
            },
            @{
                Name      = 'TaskId'
                Mandatory = $true
                Type      = 'string'
            },
            @{
                Name      = 'TaskVersion'
                Mandatory = $true
                Type      = 'version'
            },
            @{
                Name      = 'FileName'
                Mandatory = $false
                Type      = 'string'
            },
            @{
                Name      = 'InputObject'
                Mandatory = $true
                Type      = 'psobject[]'
            }
        )

        It 'Should have parameter <_.Name>' -TestCases $TestCases {
            Get-Command Save-ADOPSPipelineTask | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }

        It 'Should have ParameterSet "InputData" for single download and manual input' {
            (Get-Command Save-ADOPSPipelineTask).ParameterSets.name | Should -Contain 'InputData'
        }

        It 'Should have ParameterSet "InputObject" for multiple downloads and automatic input' {
            (Get-Command Save-ADOPSPipelineTask).ParameterSets.name | Should -Contain 'InputObject'
        }
    }

    Context 'Functionality' {
        BeforeAll {
            $InputData = @{
                TaskId      = '032b764c-18ee-4623-bce0-be59056280e8'
                TaskVersion = '1.234.56'
            }
            $InputObject = @'
[
    {
    "id": "e213ff0f-5d5c-4791-802d-52ea3e7be1f1",
    "name": "PowerShell",
    "version": {
        "major": 1,
        "minor": 2,
        "patch": 3,
        "isTest": false
    }
    },
    {
    "id": "e213ff0f-5d5c-4791-802d-52ea3e7be1f1",
    "name": "PowerShell",
    "version": {
        "major": 2,
        "minor": 212,
        "patch": 0,
        "isTest": false
    }
    }
]
'@ | ConvertFrom-Json -AsHashtable

            Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'DummyOrg' }

            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {}
        }

        It 'Should not get organization from GetADOPSDefaultOrganization when organization parameter is used' {
            Save-ADOPSPipelineTask -Organization 'DummyOrg' @InputData
            Should -Invoke GetADOPSDefaultOrganization -ModuleName ADOPS -Times 0 -Exactly
        }

        It 'Should get organization using GetADOPSDefaultOrganization when organization parameter is not used' {
            Save-ADOPSPipelineTask @InputData
            Should -Invoke GetADOPSDefaultOrganization -ModuleName ADOPS -Times 1 -Exactly
        }

        It 'Should run InvokeADOPSRestMethod with the OutFile parameter set, one file' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $OutFile
            } -ParameterFilter { $OutFile }
            Save-ADOPSPipelineTask @InputData

            Should -Invoke InvokeADOPSRestMethod -ModuleName ADOPS -Times 1 -Exactly
        }

        It 'Should run InvokeADOPSRestMethod with the OutFile parameter set, Object containing 2 files' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $OutFile
            } -ParameterFilter { $OutFile }
            Save-ADOPSPipelineTask -InputObject $InputObject

            Should -Invoke InvokeADOPSRestMethod -ModuleName ADOPS -Times 2 -Exactly
        }

        It 'InputObject should be positional' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $OutFile
            } -ParameterFilter { $OutFile }
            Save-ADOPSPipelineTask $InputObject

            Should -Invoke InvokeADOPSRestMethod -ModuleName ADOPS -Times 2 -Exactly
        }

        It 'InputObject should accept pipeline input' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $OutFile
            } -ParameterFilter { $OutFile }
            $InputObject | Save-ADOPSPipelineTask

            Should -Invoke InvokeADOPSRestMethod -ModuleName ADOPS -Times 2 -Exactly
        }
    }
}