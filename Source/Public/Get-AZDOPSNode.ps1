function Get-AZDOPSNode {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Organization,

        [Parameter(Mandatory)]
        [int32]$PoolId
    )

    if (-not [string]::IsNullOrEmpty($Organization)) {
        $Org = GetAZDOPSHeader -Organization $Organization
    } else {
        $Org = GetAZDOPSHeader
        $Organization = $Org['Organization']
    }

    $Uri = "https://dev.azure.com/$Organization/_apis/distributedtask/elasticpools/$PoolId/nodes?api-version=7.1-preview.1"

    $Method = 'GET'
    $NodeInfo = (InvokeAZDOPSRestMethod -Uri $Uri -Method $Method -Organization $Organization).value

    Write-Output $NodeInfo
}