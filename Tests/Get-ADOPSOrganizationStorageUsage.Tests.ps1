param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'Get-ADOPSOrganizationStorageUsage' {
    Context 'Parameters' {
        $TestCases = @(
            @{
                Name      = 'Organization'
                Mandatory = $false
                Type      = 'string'
            },
            @{
                Name      = 'PolicyCategory'
                Mandatory = $false
                Type      = 'string'
            }
        )

        It 'Should have parameter <_.Name>' -TestCases $TestCases {
            Get-Command Get-ADOPSOrganizationStorageUsage | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }
    
    Context 'Getting Organization Policies' {
        BeforeAll {

            Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'DummyOrg' }

            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return @'
                {
                    "meterId": "3efc2e47-d73e-4213-8368-3a8723ceb1cc",
                    "meterKind": "artifacts",
                    "isInTrial": false,
                    "maxQuantity": 2.0,
                    "currentQuantity": 0.5636861240491271,
                    "availableQuantity": 1.436313875950873,
                    "freeQuantity": 2.0,
                    "lastUsageDateTime": "2025-04-09T13:00:28.3623585Z"
                }
'@ | ConvertFrom-Json
            }
        }
        
        It 'uses InvokeADOPSRestMethod single times' {
            Get-ADOPSOrganizationStorageUsage -Organization $OrganizationName
            Should -Invoke 'InvokeADOPSRestMethod' -ModuleName 'ADOPS' -Exactly -Times 1
        }
        It 'should not throw with optional parameters' {
            { Get-ADOPSOrganizationStorageUsage -MeterId $MeterId } | Should -Not -Throw
        }
        It 'should return meterId' {
            (Get-ADOPSOrganizationStorageUsage).meterId | Should -Not -BeNullOrEmpty
        }
    }
}
