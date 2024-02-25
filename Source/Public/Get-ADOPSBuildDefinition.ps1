function Get-ADOPSBuildDefinition {
    [CmdletBinding()]
    Param(
        [Parameter()]
        [string]$Organization,
        
        [Parameter(Mandatory)]
        [string]$Project,
        
        [Parameter()]
        [int]$Id
    )

    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }

    if ($PSBoundParameters.ContainsKey('Id')) {
        [int[]]$idList = $id
    }
    else {
        [int[]]$idList = (InvokeADOPSRestMethod -Method GET -Uri "https://dev.azure.com/${Organization}/${Project}/_apis/build/definitions?api-version=7.2-preview.7").value.id
    }

    [array]$res = @()
    foreach ($definition in $idList) {
        [array]$res += InvokeADOPSRestMethod -Method GET -Uri "https://dev.azure.com/${Organization}/${Project}/_apis/build/definitions/${definition}?api-version=7.2-preview.7"
    }

    Write-Output $res -NoEnumerate
}