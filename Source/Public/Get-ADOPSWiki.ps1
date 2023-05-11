function Get-ADOPSWiki {
    param (
        [Parameter(Mandatory)]
        [string]$Project,

        [Parameter()]
        [string]$WikiId,

        [Parameter()]
        [string]$Organization
    )
 
    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }

    $BaseUri = "https://dev.azure.com/$Organization/$Project/_apis/wiki/wikis"
    
    if ($WikiId) {
        $Uri = "${BaseUri}/${WikiId}?api-version=7.1-preview.2"
    }
    else {
        $Uri = "${BaseUri}?api-version=7.1-preview.2"
    }

    $Method = 'Get'

    $res = InvokeADOPSRestMethod -Uri $URI -Method $Method
    
    if ($res.psobject.properties.name -contains 'value') {
        Write-Output -InputObject $res.value
    }
    else {
        Write-Output -InputObject $res
    }
}