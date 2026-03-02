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
        # In certain Linux dists Clear-AzTokenCache will throw an error due to missing dependencies. This catch is just a way to mute those errors.
        Write-Verbose "Failed to clear tokencache."
    }
}