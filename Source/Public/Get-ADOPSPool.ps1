function Get-ADOPSPool {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'PoolId')]
        [int32]$PoolId,

        [Parameter(Mandatory, ParameterSetName = 'PoolName')]
        [string]$PoolName,

        # Include legacy pools
        [Parameter(ParameterSetName = 'All')]
        [switch]$IncludeLegacy,

        [Parameter()]
        [string]$Organization
    )

    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }

    switch ($PSCmdlet.ParameterSetName) {
        'PoolId' { $Uri = "https://dev.azure.com/$Organization/_apis/distributedtask/pools/$PoolId`?api-version=7.1-preview.1" }
        'PoolName' { $uri = "https://dev.azure.com/$Organization/_apis/distributedtask/pools?poolName=$PoolName`&api-version=7.1-preview.1" }
        'All' { $Uri = "https://dev.azure.com/$Organization/_apis/distributedtask/pools?api-version=7.1-preview.1" }
    }
    
    $Method = 'GET'
    $PoolInfo = InvokeADOPSRestMethod -Uri $Uri -Method $Method

    if ($PoolInfo.psobject.properties.name -contains 'value') {
        $PoolInfo = $PoolInfo.value
    }
    if ((-not ($IncludeLegacy.IsPresent)) -and $PSCmdlet.ParameterSetName -eq 'All') {
        $PoolInfo = $PoolInfo | Where-Object { $_.IsLegacy -eq $false }
    }
    Write-Output $PoolInfo
}