function New-ADOPSServiceConnection {
    [cmdletbinding(DefaultParameterSetName = 'ServicePrincipal')]
    param(
        [Parameter()]
        [string]$Organization,
        
        [Parameter(Mandatory)]
        [string]$TenantId,

        [Parameter(Mandatory)]
        [string]$SubscriptionName,

        [Parameter(Mandatory)]
        [string]$SubscriptionId,

        [Parameter(Mandatory)]
        [string]$Project,

        [Parameter()]
        [string]$ConnectionName,

        [Parameter()]
        [string]$Description,
      
        [Parameter(Mandatory, ParameterSetName = 'ServicePrincipal')]
        [Parameter(Mandatory, ParameterSetName = 'ManagedServiceIdentity')]
        [pscredential]$ServicePrincipal,

        [Parameter(Mandatory, ParameterSetName = 'ManagedServiceIdentity')]
        [switch]$ManagedIdentity,

        [Parameter(Mandatory, ParameterSetName = 'WorkloadIdentityFederation')]
        [switch]$WorkloadIdentityFederation,

        [Parameter(ParameterSetName = 'WorkloadIdentityFederation')]
        [string]$AzureScope,

        [Parameter(ParameterSetName = 'WorkloadIdentityFederation')]
        [ValidateSet('Manual', 'Automatic')]
        [string]
        $CreationMode = 'Automatic'
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
            if ($PSBoundParameters.ContainsKey('AzureScope')) {
                $AuthParams =  [ordered]@{
                    tenantid = $TenantId
                    scope    = $AzureScope
                }
            } else {
                 $AuthParams =  [ordered]@{
                    tenantid = $TenantId
                }
            }

            $authorization = [ordered]@{
                parameters = $AuthParams
                scheme     = 'WorkloadIdentityFederation'
            }
    
            $data = [ordered]@{
                subscriptionId   = $SubscriptionId
                subscriptionName = $SubscriptionName
                environment      = 'AzureCloud'
                scopeLevel       = 'Subscription'
                creationMode     = $CreationMode
                isDraft          = ($CreationMode = 'Manual') ? $True : $False
            }
        }
    }

    # Create body for the API call
    $Body = [ordered]@{
        data                             = $data
        name                             = $ConnectionName
        description                      = $Description
        type                             = 'AzureRM'
        url                              = 'https://management.azure.com/'
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

    InvokeADOPSRestMethod @InvokeSplat
}