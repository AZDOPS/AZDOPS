function Revoke-ADOPSPipelinePermission {
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
        [string]$Organization
    )

    SetADOPSPipelinePermission @PSBoundParameters -Authorized $false
}