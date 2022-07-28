BeforeDiscovery {
    . $PSScriptRoot\TestHelpers.ps1
    Initialize-TestSetup
}

Describe 'ADOPSServiceConnection' {
    Context 'Parameter validation' {
        It 'Has parameter <_.Name>' -TestCases @(
            @{ Name = 'TenantId'; Mandatory = $true }
            @{ Name = 'SubscriptionName'; Mandatory = $true }
            @{ Name = 'SubscriptionId'; Mandatory = $true }
            @{ Name = 'Project'; Mandatory = $true }
            @{ Name = 'ServicePrincipal'; Mandatory = $true }
            @{ Name = 'ConnectionName'; }
            @{ Name = 'Organization'; }
        ) {
            Get-Command -Name New-ADOPSServiceConnection | Should -HaveParameterStrict $Name -Mandatory:([bool]$Mandatory) -Type $Type
        }
    }
}
