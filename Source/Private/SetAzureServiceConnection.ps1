function SewAzureServiceConnection {
    param(
        [string]$Organization,

        [string]$TenantId,

        [string]$SubscriptionName,

        [string]$SubscriptionId,

        [string]$Project,

        [string]$ConnectionName,
      
        [pscredential]$ServicePrincipal,

        [switch]$ManagedIdentity,

        [switch]$WorkloadIdentityFederation,

        [string]$AzureScope
    )

    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }
    
    # Get ProjectId
    $ProjectInfo = Get-ADOPSProject -Organization $Organization -Project $Project
    
    # Set connection name if not set by parameter
    if (-not $ConnectionName) {
        $ConnectionName = $SubscriptionName -replace " "
    }
    
    switch ($PSCmdlet.ParameterSetName) {
            
        'ServicePrincipal' {
            $authorization = [ordered]@{
                parameters = [ordered]@{
                    tenantid            = $TenantId
                    serviceprincipalid  = $ServicePrincipal.UserName
                    authenticationType  = "spnKey"
                    serviceprincipalkey = $ServicePrincipal.GetNetworkCredential().Password
                }
                scheme     = "ServicePrincipal"
            }
            
            $data = [ordered]@{
                subscriptionId   = $SubscriptionId
                subscriptionName = $SubscriptionName
                environment      = "AzureCloud"
                scopeLevel       = "Subscription"
                creationMode     = "Manual"
            }
        }
        
        'ManagedServiceIdentity' {
            $authorization = [ordered]@{
                parameters = [ordered]@{
                    tenantid = $TenantId
                }
                scheme     = "ManagedServiceIdentity"
            }
        }
    }
    
    # Create body for the API call
    $Body = [ordered]@{
        authorization                    = $authorization
        data                             = $data
        description                      = "$Description"
        id                               = $ServiceConnectionId
        isReady                          = $true
        isShared                         = $false
        name                             = ($SubscriptionName -replace " ")
        serviceEndpointProjectReferences = @(
            [ordered]@{
                projectReference = [ordered]@{
                    id   = $ProjectInfo.Id
                    name = $Project
                }
                name             = $ConnectionName
            }
        )
        type                             = "AzureRM"
        url                              = "https://management.azure.com/"
    } | ConvertTo-Json -Depth 10
        
    if ($PSBoundParameters.ContainsKey('EndpointOperation')) {
        $URI = "https://dev.azure.com/$Organization/_apis/serviceendpoint/endpoints/$ServiceEndpointId`?operation=$EndpointOperation`&api-version=7.1-preview.4"
    }
    else {
        $URI = "https://dev.azure.com/$Organization/_apis/serviceendpoint/endpoints/$ServiceEndpointId`?api-version=7.1-preview.4"
    }
            
    $InvokeSplat = @{
        Uri    = $URI
        Method = "PUT"
        Body   = $Body
    }
        
    InvokeADOPSRestMethod @InvokeSplat
}