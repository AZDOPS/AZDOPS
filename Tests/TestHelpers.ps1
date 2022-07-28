function Initialize-TestSetup {
    [CmdletBinding()]
    param ()
    Remove-Module ADOPS -Force -ErrorAction Ignore
    Import-Module $PSScriptRoot\..\Source\ADOPS -Force
    Import-Module $PSScriptRoot\assertions\HaveParameterStrict.psm1 -DisableNameChecking -ErrorAction Stop
}
