function Get-ADOPSConnection {
    [SkipTest('HasOrganizationParameter')]
    param ()
    
    $res = GetADOPSConfigFile
    $res['Default']
}