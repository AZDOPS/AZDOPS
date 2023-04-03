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
        $r = $Script:ADOPSCredentials[$Organization]
        if ($null -eq $r) {
            throw "No organization named $Organization found."
        }
        if ($r.OAuthToken.ExpiresOn -lt (Get-Date)) {
            # Token has expired. Try to renew
            $r.OAuthToken = (NewAzToken)[$Organization].OauthToken
        }
        $HeaderObj = $r.OauthToken.token
        $res.Add('Organization', $Organization)
    }
    else {
        $r = $script:ADOPSCredentials.Keys | Where-Object {$script:ADOPSCredentials[$_].Default -eq $true}
        if ($null -eq $r) {
            throw 'No default organization set. Please state organization, or use "Set-ADOPSConnection -DefaultOrganization $myOrg"'
        }
        if ($Script:ADOPSCredentials[$r].OAuthToken.ExpiresOn -lt (Get-Date)) {
            # Token has expired. Try to renew
            $Script:ADOPSCredentials[$r].OAuthToken = (NewAzToken)[$Organization].OauthToken
        }
        $HeaderObj = $script:ADOPSCredentials[$r].OauthToken.token
        $res.Add('Organization', $r)
    }

    $Header = @{
        Authorization = ("Bearer {0}" -f $HeaderObj)
    }

    $Res.Add('Header',$Header)

    $Res
}