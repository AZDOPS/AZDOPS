---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# New-ADOPSServiceConnection

## SYNOPSIS
Create an Azure DevOps Service Connection to Azure.

## SYNTAX

### ServicePrincipal (Default)
```
New-ADOPSServiceConnection [-Organization <String>] -TenantId <String> -SubscriptionName <String>
 -SubscriptionId <String> -Project <String> [-ConnectionName <String>] -ServicePrincipal <PSCredential>
 [<CommonParameters>]
```

### ManagedServiceIdentity
```
New-ADOPSServiceConnection [-Organization <String>] -TenantId <String> -SubscriptionName <String>
 -SubscriptionId <String> -Project <String> [-ConnectionName <String>] -ServicePrincipal <PSCredential>
 [-ManagedIdentity] [<CommonParameters>]
```

### WorkloadIdentityFederation
```
New-ADOPSServiceConnection [-Organization <String>] -TenantId <String> -SubscriptionName <String>
 -SubscriptionId <String> -Project <String> [-ConnectionName <String>] [-WorkloadIdentityFederation]
 -AzureScope <String> [<CommonParameters>]
```

## DESCRIPTION
Creates an Azure DevOps Service Connection to Azure subscription using an existing Service Principal. Assign the necessary permissions in Azure for the service principal.

## EXAMPLES

### Example 1
```powershell
$Params = @{
    TenantId = "32238a3e-4aae-4a9d-a3be-5c2912088b9b"
    SubscriptionName = "My Subscription"
    SubscriptionId = "34dacce0-5332-4b27-a804-4352202aca27"
    ServicePrincipal = Get-Credential
    Project = "My DevOps Project"
    ConnectionName = "My Service Connection Name"
}
New-ADOPSServiceConnection @Params
```

Creates an Azure DevOps Service Connection to an Azure subscription using an existing Service Principal object in Azure AD.

### Example 2
```powershell
$Params = @{
    TenantId = "32238a3e-4aae-4a9d-a3be-5c2912088b9b"
    SubscriptionName = "My Subscription"
    SubscriptionId = "34dacce0-5332-4b27-a804-4352202aca27"
    ServicePrincipal = Get-Credential
    Project = "My DevOps Project"
    ConnectionName = "My Service Connection Name"
    ManagedIdentity = $true
}
New-ADOPSServiceConnection @Params
```

Creates an Azure DevOps Service Connection to an Azure subscription using a managed service principal in Azure AD.

### Example 3
```powershell
$Params = @{
    TenantId = "32238a3e-4aae-4a9d-a3be-5c2912088b9b"
    SubscriptionName = "My Subscription"
    SubscriptionId = "34dacce0-5332-4b27-a804-4352202aca27"
    Project = "My DevOps Project"
    ConnectionName = "My Service Connection Name"
    WorkloadIdentityFederation = $true
    AzureScope = (Get-AzResourceGroup -Name MyAzureRG).ResourceId
}
New-ADOPSServiceConnection @Params
```

Creates an Azure DevOps Service Connection to an Azure resource group using workload identity federation (OAuth) and automatically creating an app registration in Azure AD.

## PARAMETERS

### -AzureScope
resource group ID where the app registration will be granted contributor access.
/subscriptions/4ba9b4a1-dc0d-4ec8-adaf-061771ccd1da/resourceGroups/MyAzureRG

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

### -ManagedIdentity
If a managed identity will be used for the connection.

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
Name of Azure DevOps project.

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

### -ServicePrincipal
Azure AD Service principal, Application (Client) ID and valid secret.

```yaml
Type: PSCredential
Parameter Sets: ServicePrincipal, ManagedServiceIdentity
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

### -WorkloadIdentityFederation
If Workload identity federation will be used for the connection.

```yaml
Type: SwitchParameter
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

[serviceconnection-create](https://docs.microsoft.com/en-us/rest/api/azure/devops/serviceendpoint/endpoints/create?view=azure-devops-rest-6.0)