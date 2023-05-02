function Set-ADOPSPipelinePermission {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ParameterSetName = 'AllPipelines')]
        [Parameter(Mandatory, ParameterSetName = 'SinglePipeline')]
        [string]$Project,

        [Parameter(Mandatory, ParameterSetName = 'AllPipelines')]
        [switch]$AllPipelines,

        [Parameter(Mandatory, ParameterSetName = 'SinglePipeline')]
        [int]$PipelineId,

        [Parameter(Mandatory, ParameterSetName = 'AllPipelines')]
        [Parameter(Mandatory, ParameterSetName = 'SinglePipeline')]
        [ResourceType]$ResourceType,

        [Parameter(Mandatory, ParameterSetName = 'AllPipelines')]
        [Parameter(Mandatory, ParameterSetName = 'SinglePipeline')]
        [string]$ResourceId,

        [Parameter(ParameterSetName = 'AllPipelines')]
        [Parameter(ParameterSetName = 'SinglePipeline')]
        [bool]$Authorized = $true,

        [Parameter(ParameterSetName = 'AllPipelines')]
        [Parameter(ParameterSetName = 'SinglePipeline')]
        [string]$Organization
    )

    if ([string]::IsNullOrEmpty($Organization)) {
        $Org = GetADOPSHeader
        $Organization = $Org['Organization']
    }
    else {
        $Org = GetADOPSHeader -Organization $Organization
    }
    
    $URI = "https://dev.azure.com/${Organization}/${Project}/_apis/pipelines/pipelinepermissions/${ResourceType}/${ResourceId}?api-version=7.0-preview.1"
    $method = 'PATCH'

    $Body = switch ($PSCmdlet.ParameterSetName) {
        'AllPipelines' {
            @{
                allPipelines = @{
                    authorized = $Authorized
                }
            }
        }
        'SinglePipeline' {
            @{
                pipelines = @(
                    [ordered]@{
                        id         = $PipelineId
                        authorized = $Authorized
                    }
                )
            }
        }
        'Default' {
            throw 'Invalid parameter set, this should not happen'
        }
    }
    $Body = $Body | ConvertTo-Json -Depth 10 -Compress

    InvokeADOPSRestMethod -Uri $Uri -Method $Method -Body $Body -Organization $Organization
}
