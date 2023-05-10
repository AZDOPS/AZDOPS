function Get-ADOPSPipeline {
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

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
        Method       = 'Get'
        Uri          = $URI
        Organization = $Organization
    }

    $AllPipelines = (InvokeADOPSRestMethod @InvokeSplat).value

    if ($PSBoundParameters.ContainsKey('Name')) {
        $Pipelines = $AllPipelines | Where-Object {$_.name -eq $Name}
        if (-not $Pipelines) {
            throw "The specified PipelineName $Name was not found amongst pipelines: $($AllPipelines.name -join ', ')!" 
        } 
    } else {
        $Pipelines = $AllPipelines
    }

    $return = @()

    foreach ($Pipeline in $Pipelines) {

        $InvokeSplat = @{
            Method       = 'Get'
            Uri          = $Pipeline.url
            Organization = $Organization
        }
    
        $result = InvokeADOPSRestMethod @InvokeSplat

        $return += $result
    }

    return $return
}

