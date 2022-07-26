function Get-ADOPSNode {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [int32]$PoolId,

        [Parameter()]
        [string]$Organization
    )

    if (-not [string]::IsNullOrEmpty($Organization)) {
        $Org = GetADOPSHeader -Organization $Organization
    } else {
        $Org = GetADOPSHeader
        $Organization = $Org['Organization']
    }

    $Uri = "https://dev.azure.com/$Organization/_apis/distributedtask/elasticpools/$PoolId/nodes?api-version=7.1-preview.1"

    $Method = 'GET'
    $NodeInfo = InvokeADOPSRestMethod -Uri $Uri -Method $Method -Organization $Organization

    if ($NodeInfo.psobject.properties.name -contains 'value') {
        Write-Output $NodeInfo.value
    } else {
        Write-Output $NodeInfo
    }
}