param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'Get-ADOPSResourceUsage' {
    Context 'Parameters' {
        $TestCases = @(
            @{
                Name      = 'Organization'
                Mandatory = $false
                Type      = 'string'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases {
            Get-Command Get-ADOPSResourceUsage | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }
    
    Context 'functionality' {
        BeforeAll {
            Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'DummyOrg' }

            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return @'
                {
                "count": 2,
                "value": {
                    "Projects": {
                        "count": 16,
                        "limit": 1000
                    },
                    "Work Item Tags": {
                        "count": 2614,
                        "limit": 150000
                    }
                }
                }               
'@ | ConvertFrom-Json
            }
        }

        It 'Should return something' {
            Get-ADOPSResourceUsage | Should -Not -BeNullOrEmpty
        }
    }
}