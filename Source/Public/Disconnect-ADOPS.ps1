function Disconnect-ADOPS {
    [CmdletBinding()]
    [SkipTest('HasOrganizationParameter')]
    param ()

    # Reset context
    NewADOPSConfigFile

    Clear-AzTokenCache -TokenCache $script:AzTokenCache
}