function Clear-ADOPSContext {
    [CmdletBinding()]
    [SkipTest('HasOrganizationParameter')]
    param ()

    NewADOPSConfigFile
}