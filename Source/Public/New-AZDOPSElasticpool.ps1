function New-AZDOPSElasticPool {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$PoolName,
        
        # Request body found at https://docs.microsoft.com/en-us/rest/api/azure/devops/distributedtask/elasticpools/create?view=azure-devops-rest-7.1
        [Parameter(Mandatory)]
        [string]
        $Body,

        [string]$Organization,
        
        [Parameter()]
        [guid]
        $ProjectId,

        [Parameter()]
        [boolean]
        $AuthorizeAllPipelines = $false,

        [Parameter()]
        [boolean]
        $AutoProvisionProjectPools = $false

    )

    if (-not [string]::IsNullOrEmpty($Organization)) {
        $Org = GetAZDOPSHeader -Organization $Organization
    } else {
        $Org = GetAZDOPSHeader
        $Organization = $Org['Organization']
    }

    if ($PSBoundParameters.ContainsKey('ProjectId')) {
        $Uri = "https://dev.azure.com/$Organization/_apis/distributedtask/elasticpools?poolName=$PoolName`&authorizeAllPipelines=$AuthorizeAllPipelines`&autoProvisionProjectPools=$AutoProvisionProjectPools&projectId={projectId}&api-version=7.1-preview.1"
    } else {
        $Uri = "https://dev.azure.com/$Organization/_apis/distributedtask/elasticpools?poolName=$PoolName`&authorizeAllPipelines=$AuthorizeAllPipelines`&autoProvisionProjectPools=$AutoProvisionProjectPools&api-version=7.1-preview.1"
    }
    
    $Method = 'POST'
    $ElasticPoolInfo = InvokeAZDOPSRestMethod -Uri $Uri -Method $Method -Organization $Organization -Body $Body
    Write-Output $ElasticPoolInfo
}