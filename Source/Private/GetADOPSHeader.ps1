function GetADOPSHeader {
    [CmdletBinding()]
    param (
        [string]$Organization
    )

    $Res = @{}
    
    if (-not [string]::IsNullOrEmpty($Organization)) {
        $HeaderObj = $Script:ADOPSCredentials[$Organization]
        $res.Add('Organization', $Organization)
    }
    else {
        $r = $script:ADOPSCredentials.Keys | Where-Object {$script:ADOPSCredentials[$_].Default -eq $true}
        $HeaderObj = $script:ADOPSCredentials[$r]
        $res.Add('Organization', $r)
    }

    $UserName = $HeaderObj.Credential.UserName
    $Password = $HeaderObj.Credential.GetNetworkCredential().Password

    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $UserName, $Password)))
    $Header = @{
        Authorization = ("Basic {0}" -f $base64AuthInfo)
    }

    $Res.Add('Header',$Header)

    $Res
}