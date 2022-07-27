BeforeDiscovery {
    . $PSScriptRoot\TestHelpers.ps1
    Initialize-TestSetup
}

Describe 'ADOPSServiceConnection' {
    Context 'Function tests' {
        It 'We have a function' {
            Get-Command New-ADOPSServiceConnection -Module ADOPS | Should -Not -BeNullOrEmpty
        }
    }
}

