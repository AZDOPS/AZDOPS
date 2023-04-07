function Set-ADOPSConnection {
    Param(
        [string]$DefaultOrganization
    )

    if ($script:ADOPSCredentials.Count -eq 0) {
        # No previous connection made. Initiate it.
        $null = GetADOPSHeader -Organization $DefaultOrganization
    }

    $r = $script:ADOPSCredentials.Keys | Where-Object {$script:ADOPSCredentials[$_].Default -eq $true}
    foreach ($key in $r) {
        $script:ADOPSCredentials[$key].Default = $false
    }

    try {
        $script:ADOPSCredentials[$DefaultOrganization].Default = $true
    }
    catch {
        throw "No organization with name $DefaultOrganization found."
    }
} 