---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Set-ADOPSServiceConnection

## SYNOPSIS
Allows update of a Azure DevOps Service Connection.

## SYNTAX

### ServicePrincipal (Default)
```
Set-ADOPSServiceConnection [-Organization <String>] -TenantId <String> -SubscriptionName <String>
 -SubscriptionId <String> -Project <String> -ServiceEndpointId <Guid> [-ConnectionName <String>]
 [-Description <String>] [-EndpointOperation <String>] -ServicePrincipal <PSCredential> [<CommonParameters>]
```

### ManagedServiceIdentity
```
Set-ADOPSServiceConnection [-Organization <String>] -TenantId <String> -SubscriptionName <String>
 -SubscriptionId <String> -Project <String> -ServiceEndpointId <Guid> [-ConnectionName <String>]
 [-Description <String>] [-EndpointOperation <String>] [-ManagedIdentity] 
 [<CommonParameters>]
```

### WorkloadIdentityFederation
```
Set-ADOPSServiceConnection [-Organization <String>] -TenantId <String> -SubscriptionName <String>
 -SubscriptionId <String> -Project <String> -ServiceEndpointId <Guid> [-ConnectionName <String>]
 [-Description <String>] [-EndpointOperation <String>] -ServicePrincipalId <String>
 -WorkloadIdentityFederationIssuer <String> -WorkloadIdentityFederationSubject <String>
 [<CommonParameters>]
```

## DESCRIPTION
If a managed identity will be used for the connection.

## EXAMPLES

### Example 1
```powershell
$ApplicationName = 'demo-vmss-scaling-app' 
$App = Get-AzADApplication -DisplayName $ApplicationName
$AppCreds = New-AzADAppCredential -ApplicationId $App.AppId -EndDate (Get-Date).AddDays(7)
$ServicePrincipal = Get-AzADServicePrincipal -ApplicationId $App.AppId

$ServiceEndpoint = Get-ADOPSServiceConnection -Name "$ApplicationName-serviceconnection" -Project 'Azure'

$ServiceConnectionParams = @{
    TenantId = '34ca78c2-d872-455a-9977-88e161bd4ac0'
    SubscriptionName = 'MySubscriptionName'
    SubscriptionId = '8671f1d1-0bb1-4be0-b73c-6a8f3b354cf6'
    ConnectionName = $ServiceEndpoint.name
    Project = 'Azure'
    Organization = 'MyOrganization'
    ServiceEndpointId = $ServiceEndpoint.id
    Description = 'Service Principal to manage scaling of the VMSS.'
    ServicePrincipal= [pscredential]::new($ServicePrincipal.AppId,$(ConvertTo-SecureString -AsPlainText -Force $AppCreds.SecretText))
}
Set-ADOPSServiceConnection @ServiceConnectionParams
```

Updates the Service Connection called 'demo-vmss-scaling-app-serviceconnection' in the project called 'Azure' with a new secret.

## PARAMETERS

### -ConnectionName
Name of Service Connection in Azure DevOps.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
The description field of the Service connection.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndpointOperation
Undocumented.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ManagedIdentity
If a managed identity is to be used by the Service Connection.

```yaml
Type: SwitchParameter
Parameter Sets: ManagedServiceIdentity
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Organization
Name of Azure DevOps organization.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Project
Name of the Azure DevOps project.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServiceEndpointId
The GUID of the Azure DevOps Service Endpoint.

```yaml
Type: Guid
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServicePrincipal
Azure AD Service principal, Application (Client) ID and valid secret.

```yaml
Type: PSCredential
Parameter Sets: ServicePrincipal
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SubscriptionId
The subscription id that the service connection will be connected to.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SubscriptionName
The subscription name that the service connection will be connected to.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TenantId
The tenant id connected to your Azure AD and subscriptions.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServicePrincipalId
Id of the Service Principal to be used for Federation.

```yaml
Type: String
Parameter Sets: WorkloadIdentityFederation
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WorkloadIdentityFederationIssuer
Federation issuer.

```yaml
Type: String
Parameter Sets: WorkloadIdentityFederation
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WorkloadIdentityFederationSubject
Federation Subject.

```yaml
Type: String
Parameter Sets: WorkloadIdentityFederation
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
