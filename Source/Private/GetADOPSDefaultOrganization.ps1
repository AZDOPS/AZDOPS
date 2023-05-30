function GetADOPSDefaultOrganization {
    [CmdletBinding()]
    [SkipTest('HasOrganizationParameter')]
    param ()

    $ADOPSConfig = GetADOPSConfigFile

    if([string]::IsNullOrWhiteSpace($ADOPSConfig['Default']['Organization'])) {
        throw 'No default organization found! Use Connect-ADOPS or set Organization parameter.'
    }
    else {
        Write-Output $ADOPSConfig['Default']['Organization']
    }
}