function NewAzToken {
    [CmdletBinding()]
    [SkipTest('HasOrganizationParameter')]
    param ()

    try {
        $tennantId = (Get-ADOPSConnection)['TenantId']
        if (-Not [string]::IsNullOrEmpty( $tennantId )) {
            $token = Get-AzToken -Resource 499b84ac-1321-427f-aa17-267ca6975798 -TenantId $tennantId
        }
        else {
            $token = Get-AzToken -Resource 499b84ac-1321-427f-aa17-267ca6975798
        }
    }
    catch {
        if ($_.Exception.GetType().FullName -eq 'Azure.Identity.CredentialUnavailableException') {
            $token = Get-AzToken -Resource 499b84ac-1321-427f-aa17-267ca6975798 -Interactive   
        }
        else {
            throw $_
        }
    }

    $token
}
