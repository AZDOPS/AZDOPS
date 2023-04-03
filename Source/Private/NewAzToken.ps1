function NewAzToken {
    param (
        [string]$ShouldBeDefault
    )

    $t = Get-AzToken -Resource 499b84ac-1321-427f-aa17-267ca6975798 

    # Get User context
    $me = Invoke-RestMethod -Method GET 'https://vssps.dev.azure.com/bjornsundling/_apis/profile/profiles/me?api-version=7.1-preview.3' -Headers @{
        Authorization = "Bearer $($t.token)"
    }

    # Get available orgs
    $Orgs = (Invoke-RestMethod -Method GET "https://app.vssps.visualstudio.com/_apis/accounts?memberId=$($me.publicAlias)&api-version=7.1-preview.1" -Headers @{
        Authorization = "Bearer $($t.token)"
    } | Select-Object -ExpandProperty value).accountName

    $res = [ordered]@{}

    foreach ($organization in $Orgs) {
        $tokenData = [ordered]@{
            OauthToken = $t
            UserContext = $me
            Default = [bool]($ShouldBeDefault -eq $organization)
        }
        $res.Add($organization, $tokenData)
    }

    $res
}