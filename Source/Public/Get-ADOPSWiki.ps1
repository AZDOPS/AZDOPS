function Get-ADOPSWiki {
    param (
        [Parameter(Mandatory)]
        [string]$Project,

        [Parameter()]
        [string]$WikiId,

        [Parameter()]
        [string]$Organization
    )
 
    if (-not [string]::IsNullOrEmpty($Organization)) {
        $OrgInfo = GetADOPSHeader -Organization $Organization
    }
    else {
        $OrgInfo = GetADOPSHeader
        $Organization = $OrgInfo['Organization']
    }

    $BaseUri = "https://dev.azure.com/$Organization/$Project/_apis/wiki/wikis"
    
    if ($WikiId) {
        $Uri = "${BaseUri}/${WikiId}?api-version=7.1-preview.2"
    }
    else {
        $Uri = "${BaseUri}?api-version=7.1-preview.2"
    }

    $Method = 'Get'

    $res = InvokeADOPSRestMethod -Uri $URI -Method $Method -Organization $Organization
    
    if ($res.psobject.properties.name -contains 'value') {
        Write-Output -InputObject $res.value
    }
    else {
        Write-Output -InputObject $res
    }
}