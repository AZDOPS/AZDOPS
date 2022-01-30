function GetAZDevOPSHeader {
    [CmdletBinding()]
    param ()

    $UserName = $Script:AZDevOPSCredentials.UserName
    $Password = $Script:AZDevOPSCredentials.GetNetworkCredential().Password


    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $UserName, $Password)))
    $Header = @{
        Authorization = ("Basic {0}" -f $base64AuthInfo)
    }

    $Header
}