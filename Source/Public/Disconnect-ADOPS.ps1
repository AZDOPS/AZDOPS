function Disconnect-ADOPS {
    [CmdletBinding()]
    [SkipTest('HasOrganizationParameter')]
    param ()

    # Reset context
    NewADOPSConfigFile

    try {
        Clear-AzTokenCache -TokenCache $script:AzTokenCache
    }
    catch {
        Write-Warning "Failed to clear tokencache."
    }
}