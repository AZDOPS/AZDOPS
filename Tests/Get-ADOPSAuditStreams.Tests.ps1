param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'Get-ADOPSAuditStreams' {
    Context 'Parameters' {
        $TestCases = @(
            @{
                Name      = 'Organization'
                Mandatory = $false
                Type      = 'string'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases {
            Get-Command Get-ADOPSAuditStreams | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }
    
    Context 'functionality' {
        BeforeAll {
            Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'DummyOrg' }

            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return @'
                {
                "count": 1,
                "value": [
                    {
                    "id": 1,
                    "consumerType": "AzureMonitorLogs",
                    "displayName": "75eca35c-6951-4492-a160-fca1ad4eb8d2",
                    "consumerInputs": {
                        "WorkspaceId": "75eca35c-6951-4492-a160-fca1ad4eb8d2",
                        "SharedKey": "************************"
                    },
                    "status": "enabled",
                    "statusReason": null,
                    "createdTime": "2025-04-09T08:19:06.88Z",
                    "updatedTime": "2025-04-09T08:19:06.88Z"
                    }
                ]
                }                
'@ | ConvertFrom-Json
            }
        }

        It 'Should return something' {
            Get-ADOPSAuditStreams | Should -Not -BeNullOrEmpty
        }
    }
}