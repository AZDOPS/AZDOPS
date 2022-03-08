function Get-ADOPSPool {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param (
        [Parameter(ParameterSetName = 'PoolId')]
        [Parameter(ParameterSetName = 'PoolName')]
        [Parameter(ParameterSetName = 'All')]
        [string]$Organization,

        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'PoolId'
        )]
        [int32]$PoolId,

        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'PoolName'
        )]
        [string]$PoolName,

        # Include legacy pools
        [Parameter(ParameterSetName = 'All')]
        [switch]
        $IncludeLegacy
    )

    if (-not [string]::IsNullOrEmpty($Organization)) {
        $Org = GetADOPSHeader -Organization $Organization
    }
    else {
        $Org = GetADOPSHeader
        $Organization = $Org['Organization']
    }

    switch ($PSCmdlet.ParameterSetName) {
        'PoolId' { $Uri = "https://dev.azure.com/$Organization/_apis/distributedtask/pools/$PoolId`?api-version=7.1-preview.1" }
        'PoolName' { $uri = "https://dev.azure.com/$Organization/_apis/distributedtask/pools?poolName=$PoolName`&api-version=7.1-preview.1" }
        'All' { $Uri = "https://dev.azure.com/$Organization/_apis/distributedtask/pools?api-version=7.1-preview.1" }
    }
    
    $Method = 'GET'
    $PoolInfo = InvokeADOPSRestMethod -Uri $Uri -Method $Method -Organization $Organization

    if ($PoolInfo.psobject.properties.name -contains 'value') {
        $PoolInfo = $PoolInfo.value
    }
    if ((-not ($IncludeLegacy.IsPresent)) -and $PSCmdlet.ParameterSetName -eq 'All') {
        $PoolInfo = $PoolInfo | Where-Object { $_.IsLegacy -eq $false }
    }
    Write-Output $PoolInfo
}