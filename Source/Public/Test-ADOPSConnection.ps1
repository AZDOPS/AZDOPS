function Test-ADOPSConnection {
    [CmdletBinding()]
    param ()

    # Test if we can fetch information regarding the logged in user from Azure DevOps
    $null -ne (GetADOPSDefaultOrganization -ErrorAction SilentlyContinue)
}
