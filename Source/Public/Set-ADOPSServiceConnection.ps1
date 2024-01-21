function Set-ADOPSServiceConnection {
    [CmdletBinding(DefaultParameterSetName = 'ServicePrincipal')]
    param (
        [Parameter()]
        [string]$Organization,
        
        [Parameter(Mandatory, ParameterSetName = 'GenericServiceConnection')]
        $ConnectionData,

        [Parameter(Mandatory, ParameterSetName = 'ServicePrincipal')]
        [Parameter(Mandatory, ParameterSetName = 'ManagedServiceIdentity')]
        [Parameter(Mandatory, ParameterSetName = 'WorkloadIdentityFederation')]
        [string]$TenantId,

        [Parameter(Mandatory, ParameterSetName = 'ServicePrincipal')]
        [Parameter(Mandatory, ParameterSetName = 'ManagedServiceIdentity')]
        [Parameter(Mandatory, ParameterSetName = 'WorkloadIdentityFederation')]
        [string]$SubscriptionName,

        [Parameter(Mandatory, ParameterSetName = 'ServicePrincipal')]
        [Parameter(Mandatory, ParameterSetName = 'ManagedServiceIdentity')]
        [Parameter(Mandatory, ParameterSetName = 'WorkloadIdentityFederation')]
        [string]$SubscriptionId,

        [Parameter(Mandatory, ParameterSetName = 'ServicePrincipal')]
        [Parameter(Mandatory, ParameterSetName = 'ManagedServiceIdentity')]
        [Parameter(Mandatory, ParameterSetName = 'WorkloadIdentityFederation')]
        [string]$Project,

        [Parameter(Mandatory, ParameterSetName = 'ServicePrincipal')]
        [Parameter(Mandatory, ParameterSetName = 'ManagedServiceIdentity')]
        [Parameter(Mandatory, ParameterSetName = 'WorkloadIdentityFederation')]
        [guid]$ServiceEndpointId,

        [Parameter(ParameterSetName = 'ServicePrincipal')]
        [Parameter(ParameterSetName = 'ManagedServiceIdentity')]
        [Parameter(ParameterSetName = 'WorkloadIdentityFederation')]
        [string]$ConnectionName,

        [Parameter(ParameterSetName = 'ServicePrincipal')]
        [Parameter(ParameterSetName = 'ManagedServiceIdentity')]
        [Parameter(ParameterSetName = 'WorkloadIdentityFederation')]
        [string]$Description,

        [ValidateNotNullOrEmpty()]
        [string]$EndpointOperation,
      
        [Parameter(Mandatory, ParameterSetName = 'ServicePrincipal')]
        [Parameter(Mandatory, ParameterSetName = 'ManagedServiceIdentity')]
        [pscredential]$ServicePrincipal,

        [Parameter(Mandatory, ParameterSetName = 'ManagedServiceIdentity')]
        [switch]$ManagedIdentity,

        [Parameter(Mandatory, ParameterSetName = 'WorkloadIdentityFederation')]
        [switch]$WorkloadIdentityFederation,

        [Parameter(Mandatory, ParameterSetName = 'WorkloadIdentityFederation')]
        [string]$AzureScope
    )
    
    if ($PSCmdlet.ParameterSetName -in "ServicePrincipal", "ManagedServiceIdentity", "WorkloadIdentityFederation") {
        return (SetAzureServiceConnection @PSBoundParameters)
    }
    elseif ($PSCmdlet.ParameterSetName -eq "GenericServiceConnection") {
        return (SetGenericServiceConnection @PSBoundParameters)
    }
}