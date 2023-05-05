param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'Set-ADOPSConnection' {
    Context 'Parameters' {
        $TestCases = @(
            @{
                Name = 'DefaultOrganization'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'AzureADTennantId'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'Persist'
                Mandatory = $false
                Type = 'switch'
            }
        )

        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command Set-ADOPSConnection | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }
}

