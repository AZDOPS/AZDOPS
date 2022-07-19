function New-ADOPSServiceConnection {
    [cmdletbinding()]
    param(
        [parameter(Mandatory = $true)]
        [string]$TenantId,

        [parameter(Mandatory = $true)]
        [string]$SubscriptionName,

        [parameter(Mandatory = $true)]
        [string]$SubscriptionId,

        [parameter(Mandatory = $true)]
        [string]$Project,

        [parameter()]
        [string]$ConnectionName,

        [parameter()]
        [string]$Organization,
      
        [Parameter(mandatory)]
        [pscredential]$ServicePrincipal
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

    # Create body for the API call
    $Body = @{
        data                             = @{
            subscriptionId   = $SubscriptionId
            subscriptionName = $SubscriptionName
            environment      = "AzureCloud"
            scopeLevel       = "Subscription"
            creationMode     = "Manual"
        }
        name                             = ($SubscriptionName -replace " ")
        type                             = "AzureRM"
        url                              = "https://management.azure.com/"
        authorization                    = @{
            parameters = @{
                tenantid            = $TenantId
                serviceprincipalid  = $ServicePrincipal.UserName
                authenticationType  = "spnKey"
                serviceprincipalkey = $ServicePrincipal.GetNetworkCredential().Password
            }
            scheme     = "ServicePrincipal"
        }
        isShared                         = $false
        isReady                          = $true
        serviceEndpointProjectReferences = @(
            @{
                projectReference = @{
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