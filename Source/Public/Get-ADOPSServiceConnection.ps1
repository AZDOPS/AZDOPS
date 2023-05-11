function Get-ADOPSServiceConnection {
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

    $Uri = "https://dev.azure.com/$Organization/$Project/_apis/serviceendpoint/endpoints?api-version=7.1-preview.4"
    
    $InvokeSplat = @{
        Method       = 'Get'
        Uri          = $URI
    }

    $AllPipelines = (InvokeADOPSRestMethod @InvokeSplat).value

    if ($PSBoundParameters.ContainsKey('Name')) {
        $Pipelines = $AllPipelines | Where-Object {$_.name -eq $Name}
        if (-not $Pipelines) {
            throw "The specified ServiceConnectionName $Name was not found amongst Connections: $($AllPipelines.name -join ', ')!" 
        } 
    } else {
        $Pipelines = $AllPipelines
    }

    return $Pipelines

}