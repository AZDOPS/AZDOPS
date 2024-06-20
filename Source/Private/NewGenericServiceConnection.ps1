function NewGenericServiceConnection {
    param (
        [string]$Organization,

        $ConnectionData
    )

    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }
    
    $URI = "https://dev.azure.com/$Organization/_apis/serviceendpoint/endpoints?api-version=7.2-preview.4"
    $InvokeSplat = @{
        Uri    = $URI
        Method = 'POST'
        Body   = $ConnectionData | ConvertTo-Json -Depth 10
    }

    $Response = InvokeADOPSRestMethod @InvokeSplat

    return $Response
}