function Initialize-TestSetup {
    [CmdletBinding()]
    param ()
    Remove-Module ADOPS -Force -ErrorAction Ignore
    Import-Module $PSScriptRoot\..\Source\ADOPS -Force
}
