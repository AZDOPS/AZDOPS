function Test-ADOPSConnection {
    [CmdletBinding()]
    [SkipTest('HasOrganizationParameter')]
    param ()

    # Test if we can fetch information regarding the logged in user from Azure DevOps
    $null -ne (GetADOPSDefaultOrganization -ErrorAction SilentlyContinue)
}
