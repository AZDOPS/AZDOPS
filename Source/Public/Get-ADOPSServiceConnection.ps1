function Get-ADOPSServiceConnection {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Project,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Organization,
        
        [Parameter()]
        [switch]
        $IncludeFailed
    )
    
    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }

    $Uri = "https://dev.azure.com/$Organization/$Project/_apis/serviceendpoint/endpoints?includeFailed=$IncludeFailed&api-version=7.1-preview.4"
    
    $InvokeSplat = @{
        Method = 'Get'
        Uri    = $URI
    }

    $ServiceConnections = (InvokeADOPSRestMethod @InvokeSplat).value

    if ($PSBoundParameters.ContainsKey('Name')) {
        $ServiceConnection = $ServiceConnections | Where-Object { $_.name -eq $Name }
        if (-not $ServiceConnection) {
            throw "The specified ServiceConnectionName $Name was not found amongst Connections: $($AllPipelines.name -join ', ')!" 
        }
        return $ServiceConnection
    }
    else {
        return $ServiceConnections
    }

}