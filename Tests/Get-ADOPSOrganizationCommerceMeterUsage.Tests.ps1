param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'Get-ADOPSOrganizationCommerceMeterUsage' {
    Context 'Parameters' {
        $TestCases = @(
            @{
                Name      = 'Organization'
                Mandatory = $false
                Type      = 'string'
            },
            @{
                Name      = 'MeterId'
                Mandatory = $false
                Type      = 'string'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases {
            Get-Command Get-ADOPSOrganizationCommerceMeterUsage | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }
    
    Context 'functionality' {
        BeforeAll {
            Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'DummyOrg' }

            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return @'
                {
                    "count": 10,
                    "value": [
                        {
                        "meterId": "2586716a-fa90-4760-984d-3e6d9f9f3b1d",
                        "isInTrial": false,
                        "maxQuantity": 50000.0,
                        "currentQuantity": 339.0,
                        "availableQuantity": 49661.0,
                        "freeQuantity": 5.0,
                        "lastUsageDateTime": "2025-04-05T19:35:16.5950469Z"
                        },
                        {
                        "meterId": "95576bc1-dbf3-4386-9276-4fe294a3a809",
                        "isInTrial": false,
                        "maxQuantity": 20000.0,
                        "currentQuantity": 50.0,
                        "availableQuantity": 19950.0,
                        "lastUsageDateTime": "2025-04-05T19:35:17.8608581Z"
                        },
                        {
                        "meterId": "e2c73ec7-cb60-4142-b8b2-e216b6c09c1a",
                        "meterKind": "resource",
                        "isInTrial": false,
                        "maxQuantity": 50000.0,
                        "availableQuantity": 50000.0,
                        "freeQuantity": 1800.0
                        },
                        {
                        "meterId": "4bad9897-8d87-43bb-80be-5e6e8fefa3de",
                        "meterKind": "commitment",
                        "isInTrial": false,
                        "maxQuantity": 12.0,
                        "availableQuantity": 12.0
                        },
                        {
                        "meterId": "f44a67f2-53ae-4044-bd58-1c8aca386b98",
                        "meterKind": "commitment",
                        "isInTrial": false,
                        "maxQuantity": 19.0,
                        "availableQuantity": 19.0,
                        "freeQuantity": 1.0
                        },
                        {
                        "meterId": "3fa30bbe-3437-42d4-a978-0ef84811f470",
                        "meterKind": "commitment",
                        "isInTrial": false,
                        "maxQuantity": 10.0,
                        "availableQuantity": 10.0,
                        "freeQuantity": 10.0
                        },
                        {
                        "meterId": "2fa36572-3c3d-46be-ac59-6053cbb377b4",
                        "meterKind": "commitment",
                        "isInTrial": false,
                        "maxQuantity": 100000.0,
                        "availableQuantity": 100000.0,
                        "freeQuantity": 100000.0
                        },
                        {
                        "meterId": "3efc2e47-d73e-4213-8368-3a8723ceb1cc",
                        "meterKind": "artifacts",
                        "isInTrial": false,
                        "maxQuantity": 2.0,
                        "currentQuantity": 0.5680053327232599,
                        "availableQuantity": 1.43199466727674,
                        "freeQuantity": 2.0,
                        "lastUsageDateTime": "2025-04-10T13:00:29.0170587Z"
                        },
                        {
                        "meterId": "a7d460a9-a56d-4b64-837f-14728d6d54d4",
                        "meterKind": "resource",
                        "isInTrial": false,
                        "maxQuantity": 2000000000.0,
                        "availableQuantity": 2000000000.0,
                        "freeQuantity": 20000.0
                        },
                        {
                        "meterId": "256caf12-9779-4531-99ac-b46e295130a3",
                        "meterKind": "resource",
                        "isInTrial": false,
                        "maxQuantity": 1.7976931348623157E+308,
                        "currentQuantity": 296.0,
                        "availableQuantity": 1.7976931348623157E+308,
                        "lastUsageDateTime": "2025-04-10T01:56:37.6244039Z"
                        }
                    ]
                }
'@ | ConvertFrom-Json
            }
        }

        It 'Should return something' {
            Get-ADOPSOrganizationCommerceMeterUsage | Should -Not -BeNullOrEmpty
        }

        It 'Should return single meter usage data' {
            Get-ADOPSOrganizationCommerceMeterUsage -meterId '3efc2e47-d73e-4213-8368-3a8723ceb1cc' | Should -Not -BeNullOrEmpty
        }

        It 'Should return meterIds' {
            Get-ADOPSOrganizationCommerceMeterUsage | Select-object -ExpandProperty 'meterId' | Should -Not -BeNullOrEmpty
        }
    }
}