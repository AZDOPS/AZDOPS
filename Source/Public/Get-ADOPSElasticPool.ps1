function Get-ADOPSElasticPool {
    [CmdletBinding()]
    param (
        [Parameter()]
        [int32]$PoolId,

        [Parameter()]
        [string]$Organization
    )

    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }

    if ($PSBoundParameters.ContainsKey('PoolId')) {
        $Uri = "https://dev.azure.com/$Organization/_apis/distributedtask/elasticpools/$PoolId?api-version=7.1-preview.1"
    } else {
        $Uri = "https://dev.azure.com/$Organization/_apis/distributedtask/elasticpools?api-version=7.1-preview.1"
    }
    
    $Method = 'GET'
    $ElasticPoolInfo = InvokeADOPSRestMethod -Uri $Uri -Method $Method -Body $Body
    if ($ElasticPoolInfo.psobject.properties.name -contains 'value') {
        Write-Output $ElasticPoolInfo.value
    } else {
        Write-Output $ElasticPoolInfo
    }
}