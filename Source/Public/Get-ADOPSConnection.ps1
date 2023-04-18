function Get-ADOPSConnection {
    [SkipTest('HasOrganizationParameter')]
    [CmdletBinding()]
    Param()

    if ($script:ADOPSCredentials.Count -eq 0) {
        try {
            $Script:ADOPSCredentials = NewAzToken
        }
        catch {
            throw 'No usable ADOPS credentials found. Use Connect-AzAccount or az login to connect.'
        }
    }

    $script:ADOPSCredentials
} 