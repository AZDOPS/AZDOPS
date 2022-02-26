function Disconnect-ADOPS {
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Organization
    )

    # Only require $Organization if several connections
    if ($Script:ADOPSCredentials.Count -eq 0) {
        throw "There are no current connections!"
    } # Allow not specifying organization if there's only one connection
    elseif ($Script:ADOPSCredentials.Count -eq 1 -and [string]::IsNullOrWhiteSpace($Organization)) {
        $Script:ADOPSCredentials = @{}
        # Make sure to exit script after clearing hashtable
        return
    }
    elseif (-not $Script:ADOPSCredentials.ContainsKey($Organization)) {
        throw "No connection made for organization $Organization!"
    }

    # If the connection to be removed is set as default, set another one
    $ChangeDefault = $Script:ADOPSCredentials[$Organization].Default
    
    $Script:ADOPSCredentials.Remove($Organization)

    # If there are any connections left and we removed the default
    if ($Script:ADOPSCredentials.Count -gt 0 -and $ChangeDefault) {
        # Set another one to default
        $Name = ($Script:ADOPSCredentials.GetEnumerator() | Select-Object -First 1).Name
        $Script:ADOPSCredentials[$Name].Default = $true
    }
}