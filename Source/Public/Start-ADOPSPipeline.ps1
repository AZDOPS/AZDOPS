function Start-ADOPSPipeline {
    param (
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [string]$Project,

        [Parameter()]
        [string]$Branch = 'main',

        [Parameter()]
        [string]$Organization
    )

    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }

    $AllPipelinesURI = "https://dev.azure.com/$Organization/$Project/_apis/pipelines?api-version=7.1-preview.1"
    $AllPipelines = InvokeADOPSRestMethod -Method Get -Uri $AllPipelinesURI
    $PipelineID = ($AllPipelines.value | Where-Object -Property Name -EQ $Name).id

    if ([string]::IsNullOrEmpty($PipelineID)) {
        throw "No pipeline with name $Name found."
    }

    if ($Branch -notmatch '^refs/.*') {
        $Branch = 'refs/heads/' + $Branch
    }
    $URI = "https://dev.azure.com/$Organization/$Project/_apis/pipelines/$PipelineID/runs?api-version=7.1-preview.1"
    $Body = '{"stagesToSkip":[],"resources":{"repositories":{"self":{"refName":"' + $Branch + '"}}},"variables":{}}'
    
    $InvokeSplat = @{
        Method       = 'Post' 
        Uri          = $URI 
        Body         = $Body
    }

    InvokeADOPSRestMethod @InvokeSplat
}