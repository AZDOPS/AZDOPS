function Disconnect-ADOPS {
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Organization
    )

    # Reset context
    NewADOPSConfigFile
}