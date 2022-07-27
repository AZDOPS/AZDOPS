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

```
New-ADOPSServiceConnection [-TenantId] <String> [-SubscriptionName] <String> [-SubscriptionId] <String>
 [-Project] <String> [[-ConnectionName] <String>] [-ServicePrincipal] <PSCredential> [[-Organization] <String>]
 [<CommonParameters>]
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

## PARAMETERS

### -ConnectionName
Name of Service Connection in Azure DevOps.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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
Position: 6
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
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServicePrincipal
Azure AD Service principal, Application (Client) ID and valid secret-

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
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
Position: 2
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
Position: 1
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
Position: 0
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