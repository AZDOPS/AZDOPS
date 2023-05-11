function New-ADOPSElasticPool {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$PoolName,
        
        [Parameter(Mandatory)]
        $ElasticPoolObject,

        [Parameter()]
        [string]$ProjectId,

        [Parameter()]
        [switch]$AuthorizeAllPipelines,

        [Parameter()]
        [switch]$AutoProvisionProjectPools,

        [Parameter()]
        [string]$Organization
    )

    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }

    if ($PSBoundParameters.ContainsKey('ProjectId')) {
        $Uri = "https://dev.azure.com/$Organization/_apis/distributedtask/elasticpools?poolName=$PoolName`&authorizeAllPipelines=$AuthorizeAllPipelines`&autoProvisionProjectPools=$AutoProvisionProjectPools`&projectId=$ProjectId`&api-version=7.1-preview.1"
    } else {
        $Uri = "https://dev.azure.com/$Organization/_apis/distributedtask/elasticpools?poolName=$PoolName`&authorizeAllPipelines=$AuthorizeAllPipelines`&autoProvisionProjectPools=$AutoProvisionProjectPools`&api-version=7.1-preview.1"
    }

    if ($ElasticPoolObject.gettype().name -eq 'String') {
        $Body = $ElasticPoolObject
    } else {
        try {
            $Body = $ElasticPoolObject | ConvertTo-Json -Depth 100
        }
        catch {
            throw "Unable to convert the content of the ElasticPoolObject to json."
        }
    }
    
    $Method = 'POST'
    $ElasticPoolInfo = InvokeADOPSRestMethod -Uri $Uri -Method $Method -Body $Body
    Write-Output $ElasticPoolInfo
}