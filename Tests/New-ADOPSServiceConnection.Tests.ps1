Remove-Module ADOPS -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot\..\Source\ADOPS

Describe 'New-ADOPSServiceConnection' {
    Context 'Parameters' {
        $TestCases = @(
            @{
                Name = 'Organization'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'TenantId'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'SubscriptionName'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'SubscriptionId'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'Project'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'ConnectionName'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'ServicePrincipal'
                Mandatory = $true
                Type = 'pscredential'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command New-ADOPSServiceConnection | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }
}

