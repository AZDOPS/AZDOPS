function Disconnect-AZDOPS {
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Organization
    )

    # Only require $Organization if several connections
    if ($Script:AZDOPSCredentials.Count -eq 0) {
        throw "There are no current connections!"
    } # Allow not specifying organization if there's only one connection
    elseif ($Script:AZDOPSCredentials.Count -eq 1 -and [string]::IsNullOrWhiteSpace($Organization)) {
        $Script:AZDOPSCredentials = @{}
        # Make sure to exit script after clearing hashtable
        return
    }
    elseif (-not $Script:AZDOPSCredentials.ContainsKey($Organization)) {
        throw "No connection made for organization $Organization!"
    }

    # If the connection to be removed is set as default, set another one
    $ChangeDefault = $Script:AZDOPSCredentials[$Organization].Default
    
    $Script:AZDOPSCredentials.Remove($Organization)

    # If there are any connections left and we removed the default
    if ($Script:AZDOPSCredentials.Count -gt 0 -and $ChangeDefault) {
        # Set another one to default
        $Name = ($Script:AZDOPSCredentials.GetEnumerator() | Select-Object -First 1).Name
        $Script:AZDOPSCredentials[$Name].Default = $true
    }
}