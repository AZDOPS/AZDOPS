function GetADOPSHeader {
    [CmdletBinding()]
    param (
        [string]$Organization
    )

    $Res = @{}

    if ($script:ADOPSCredentials.Count -eq 0) {
        try {
            $Script:ADOPSCredentials = NewAzToken
        }
        catch {
            throw 'No usable ADOPS credentials found. Use Connect-AzAccount or az login to connect.'
        }
    }

    if (-not [string]::IsNullOrEmpty($Organization)) {
        $r = $Script:ADOPSCredentials | Where-Object {$_.organization -eq $Organization}
        if ($null -eq $r) {
            throw "No organization named $Organization found."
        }
    }
    else {
        $r = $script:ADOPSCredentials | Where-Object {$_.default}
        if ($null -eq $r) {
            throw 'No default organization set. Please state organization, or use "Set-ADOPSConnection -DefaultOrganization $myOrg"'
        }
    }

    
    if ([DateTime]$r.OAuthToken.ExpiresOn -lt (Get-Date)) {
        # Token has expired. Try to renew
        ($Script:ADOPSCredentials | Where-Object {$_.organization -eq $r.Organization}).Oauthtoken = (NewAzToken | Where-Object {$_.Organization -eq $r.Organization}).Oauthtoken
    }

    $HeaderObj = $r.OauthToken.token
    $res.Add('Organization', $r.Organization)

    $Header = @{
        Authorization = ("Bearer {0}" -f $HeaderObj)
    }

    $Res.Add('Header',$Header)

    Write-Output $Res
}