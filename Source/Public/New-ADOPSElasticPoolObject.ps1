function New-ADOPSElasticPoolObject {
    [SkipTest('HasOrganizationParameter')]
    [CmdletBinding()]
    param (
        # Service Endpoint Id
        [Parameter(Mandatory)]
        [guid]
        $ServiceEndpointId,

        # Service Endpoint Scope
        [Parameter(Mandatory)]
        [guid]
        $ServiceEndpointScope,

        # Azure Id
        [Parameter(Mandatory)]
        [string]
        $AzureId,

        # Operating System Type
        [Parameter()]
        [ValidateSet('linux', 'windows')]
        [string]
        $OsType = 'linux',

        # MaxCapacity
        [Parameter()]
        [int]
        $MaxCapacity = 1,

        # DesiredIdle
        [Parameter()]
        [int]
        $DesiredIdle = 0,

        # Recycle VM after each use
        [Parameter()]
        [boolean]
        $RecycleAfterEachUse = $false,

        # Desired Size of pool
        [Parameter()]
        [int]
        $DesiredSize = 0,

        # Agent Interactive UI
        [Parameter()]
        [boolean]
        $AgentInteractiveUI = $false,

        # Time before scaling down
        [Parameter()]
        [int]
        $TimeToLiveMinues = 15,

        # maxSavedNodeCount
        [Parameter()]
        [int]
        $MaxSavedNodeCount = 0,

        # Output Type
        [Parameter()]
        [ValidateSet('json','pscustomobject')]
        [string]
        $OutputType = 'pscustomobject'
    )

    if ($DesiredIdle -gt $MaxCapacity) {
        throw "The desired idle count cannot be larger than the max capacity."
    }

    $ElasticPoolObject = [PSCustomObject]@{
        serviceEndpointId = $ServiceEndpointId
        serviceEndpointScope = $ServiceEndpointScope
        azureId = $AzureId
        maxCapacity = $MaxCapacity
        desiredIdle = $DesiredIdle
        recycleAfterEachUse = $RecycleAfterEachUse
        maxSavedNodeCount = $MaxSavedNodeCount
        osType = $OsType
        desiredSize = $DesiredSize
        agentInteractiveUI = $AgentInteractiveUI
        timeToLiveMinutes = $TimeToLiveMinues
    }
    
    if ($OutputType -eq 'json') {
        $ElasticPoolObject = $ElasticPoolObject | ConvertTo-Json -Depth 100
    }

    Write-Output $ElasticPoolObject
}