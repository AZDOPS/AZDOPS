function SetGenericServiceConnection {
    param (
        [string]$Organization,

        $ConnectionData,

        $EndpointOperation
    )

    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }

    if (-Not ($ConnectionData.ID)) {
        throw "ConnectionData must contain a valid ID"
    }
    else {
        $ServiceEndpointId = $ConnectionData.ID
    }
    
    if ($PSBoundParameters.ContainsKey('EndpointOperation')) {
        $URI = "https://dev.azure.com/$Organization/_apis/serviceendpoint/endpoints/$ServiceEndpointId`?operation=$EndpointOperation`&api-version=7.1-preview.4"
    }
    else {
        $URI = "https://dev.azure.com/$Organization/_apis/serviceendpoint/endpoints/$ServiceEndpointId`?api-version=7.1-preview.4"
    }

    $InvokeSplat = @{
        Uri    = $URI
        Method = 'PUT'
        Body   = $ConnectionData | ConvertTo-Json -Depth 10
    }

    $Response = InvokeADOPSRestMethod @InvokeSplat

    return $Response
}