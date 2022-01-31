function Start-AZDevOPSPipeline {
    param (
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [string]$Project
    )

    $AllPipelinesURI = "https://dev.azure.com/${Script:AzDOOrganization}/$Project/_apis/pipelines?api-version=7.1-preview.1"
    $AllPipelines = InvokeAZDevOPSRestMethod -Method Get -Uri $AllPipelinesURI 
    $PipelineID = ($AllPipelines.value | Where-Object -Property Name -EQ $Name).id

    $URI = "https://dev.azure.com/${Script:AzDOOrganization}/$Project/_apis/pipelines/$PipelineID/runs?api-version=7.1-preview.1"
    $Body = '{"stagesToSkip":[],"resources":{"repositories":{"self":{"refName":"refs/heads/master"}}},"variables":{}}'
    
    InvokeAZDevOPSRestMethod -Method Post -Uri $URI -Body $Body
}