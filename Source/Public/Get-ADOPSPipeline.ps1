function Get-ADOPSPipeline {
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter()]
        [int]$Revision,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Project,
        
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Organization
    )

    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }

    $Uri = "https://dev.azure.com/$Organization/$Project/_apis/pipelines?api-version=7.1-preview.1"
    
    $InvokeSplat = @{
        Method = 'Get'
        Uri    = $URI
    }

    $AllPipelines = (InvokeADOPSRestMethod @InvokeSplat).value

    if ($PSBoundParameters.ContainsKey('Name')) {
        $Pipelines = $AllPipelines | Where-Object { $_.name -eq $Name }
        if (-not $Pipelines) {
            throw "The specified PipelineName $Name was not found amongst pipelines: $($AllPipelines.name -join ', ')!" 
        } 
    }
    else {
        $Pipelines = $AllPipelines
    }

    $return = @()

    foreach ($Pipeline in $Pipelines) {

        $pipelineRevision = [Uri]::EscapeDataString($PSBoundParameters.ContainsKey('Revision') ? $Revision : $Pipeline.revision)
        $pipelineUrl = "https://dev.azure.com/$Organization/$Project/_apis/pipelines/$($Pipeline.id)?api-version=7.1-preview.1&pipelineVersion=$pipelineRevision"

        $InvokeSplat = @{
            Method = 'Get'
            Uri    = $pipelineUrl
        }
    
        $result = InvokeADOPSRestMethod @InvokeSplat

        $return += $result
    }

    return $return
}

