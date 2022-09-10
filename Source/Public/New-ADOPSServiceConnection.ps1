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
      
        [Parameter(Mandatory, ParameterSetName = 'ServicePrincipal')]
        [pscredential]$ServicePrincipal,

        [Parameter(Mandatory, ParameterSetName = 'ManagedServiceIdentity')]
        [switch]$ManagedIdentity
    )

    # Set organization
    if (-not [string]::IsNullOrEmpty($Organization)) {
        $Org = GetADOPSHeader -Organization $Organization
    }
    else {
        $Org = GetADOPSHeader
        $Organization = $Org['Organization']
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
    
            $data = [ordered]@{
                subscriptionId   = $SubscriptionId
                subscriptionName = $SubscriptionName
                environment      = "AzureCloud"
                scopeLevel       = "Subscription"
            }
        }
    }

    # Create body for the API call
    $Body = [ordered]@{
        data                             = $data
        name                             = ($SubscriptionName -replace " ")
        type                             = "AzureRM"
        url                              = "https://management.azure.com/"
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
    $URI = "https://dev.azure.com/$Organization/$Project/_apis/serviceendpoint/endpoints?api-version=6.0-preview.4"
    $InvokeSplat = @{
        Uri          = $URI
        Method       = "POST"
        Body         = $Body
        Organization = $Organization
    }

    InvokeADOPSRestMethod @InvokeSplat

}