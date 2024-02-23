function NewAzureServiceConnection {
    param(
        [string]$Organization,

        [string]$TenantId,

        [string]$SubscriptionName,

        [string]$SubscriptionId,

        [string]$Project,

        [string]$ConnectionName,

        [string]$Description,
      
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
        $ConnectionName = $SubscriptionName -replace ' '
    }

    switch ($PSCmdlet.ParameterSetName) {

        'ServicePrincipal' {
            $authorization = [ordered]@{
                parameters = [ordered]@{
                    tenantid            = $TenantId
                    serviceprincipalid  = $ServicePrincipal.UserName
                    authenticationType  = 'spnKey'
                    serviceprincipalkey = $ServicePrincipal.GetNetworkCredential().Password
                }
                scheme     = 'ServicePrincipal'
            }

            $data = [ordered]@{
                subscriptionId   = $SubscriptionId
                subscriptionName = $SubscriptionName
                environment      = 'AzureCloud'
                scopeLevel       = 'Subscription'
                creationMode     = 'Manual'
            }
        }

        'ManagedServiceIdentity' {
            $authorization = [ordered]@{
                parameters = [ordered]@{
                    tenantid            = $TenantId
                    serviceprincipalid  = $ServicePrincipal.UserName
                    serviceprincipalkey = $ServicePrincipal.GetNetworkCredential().Password
                }
                scheme     = 'ManagedServiceIdentity'
            }

            $data = [ordered]@{
                subscriptionId   = $SubscriptionId
                subscriptionName = $SubscriptionName
                environment      = 'AzureCloud'
                scopeLevel       = 'Subscription'
            }
        }

        'WorkloadIdentityFederation' {
            $authorization = [ordered]@{
                parameters = [ordered]@{
                    tenantid = $TenantId
                    scope    = $AzureScope
                }
                scheme     = 'WorkloadIdentityFederation'
            }

            $data = [ordered]@{
                subscriptionId   = $SubscriptionId
                subscriptionName = $SubscriptionName
                environment      = 'AzureCloud'
                scopeLevel       = 'Subscription'
                creationMode     = 'Automatic'
            }
        }
    }

    # Create body for the API call
    $Body = [ordered]@{
        name                             = ($SubscriptionName -replace ' ')
        description                      = "$Description"
        type                             = 'AzureRM'
        url                              = 'https://management.azure.com/'
        data                             = $data
        authorization                    = $authorization
        isShared                         = $false
        isReady                          = $true
        serviceEndpointProjectReferences = @(
            [ordered]@{
                projectReference = [ordered]@{
                    id   = $ProjectInfo.Id
                    name = $Project
                }
                name             = $ConnectionName
            }
        )
    } | ConvertTo-Json -Depth 10

    # Run function
    $URI = "https://dev.azure.com/$Organization/$Project/_apis/serviceendpoint/endpoints?api-version=7.2-preview.4"
    $InvokeSplat = @{
        Uri    = $URI
        Method = 'POST'
        Body   = $Body
    }

    $Response = InvokeADOPSRestMethod @InvokeSplat

    return $Response
}