function SetADOPSPipelinePermission {
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

    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }
    
    $URI = "https://dev.azure.com/${Organization}/${Project}/_apis/pipelines/pipelinepermissions/${ResourceType}/${ResourceId}?api-version=7.1-preview.1"
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

    InvokeADOPSRestMethod -Uri $Uri -Method $Method -Body $Body
}
