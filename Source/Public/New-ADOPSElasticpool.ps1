function New-ADOPSElasticPool {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$PoolName,
        
        [Parameter(Mandatory)]
        $ElasticPoolObject,

        [string]$Organization,
        
        [Parameter()]
        [string]
        $ProjectId,

        [Parameter()]
        [boolean]
        $AuthorizeAllPipelines = $false,

        [Parameter()]
        [boolean]
        $AutoProvisionProjectPools = $false

    )

    if (-not [string]::IsNullOrEmpty($Organization)) {
        $Org = GetADOPSHeader -Organization $Organization
    } else {
        $Org = GetADOPSHeader
        $Organization = $Org['Organization']
    }

    if ($PSBoundParameters.ContainsKey('ProjectId')) {
        $Uri = "https://dev.azure.com/$Organization/_apis/distributedtask/elasticpools?poolName=$PoolName`&authorizeAllPipelines=$AuthorizeAllPipelines`&autoProvisionProjectPools=$AutoProvisionProjectPools&projectId=$ProjectId&api-version=7.1-preview.1"
    } else {
        $Uri = "https://dev.azure.com/$Organization/_apis/distributedtask/elasticpools?poolName=$PoolName`&authorizeAllPipelines=$AuthorizeAllPipelines`&autoProvisionProjectPools=$AutoProvisionProjectPools&api-version=7.1-preview.1"
    }
    
    $Method = 'POST'
    $ElasticPoolInfo = InvokeADOPSRestMethod -Uri $Uri -Method $Method -Organization $Organization -Body $Body
    Write-Output $ElasticPoolInfo
}