Remove-Module ADOPS -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot\..\Source\ADOPS


Describe 'ADOPSServiceConnection' {
    Context 'Function tests' {
        It 'We have a function' {
            Get-Command Get-ADOPSServiceConnection -Module ADOPS | Should -Not -BeNullOrEmpty
        }
    }
}

