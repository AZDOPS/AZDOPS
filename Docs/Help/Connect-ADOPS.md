---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Connect-ADOPS

## SYNOPSIS

Establish a connection to Azure DevOps.

## SYNTAX

### Interactive (Default)
```
Connect-ADOPS -Organization <String> [-TenantId <String>] [-Interactive] [<CommonParameters>]
```

### OAuthToken
```
Connect-ADOPS -Organization <String> [-TenantId <String>] -OAuthToken <String> [<CommonParameters>]
```

### ManagedIdentity
```
Connect-ADOPS -Organization <String> [-TenantId <String>] [-ManagedIdentity] [<CommonParameters>]
```

## DESCRIPTION

Establish a OAuth connection to one or more Azure DevOps organizations.
If the logged on user does not have access to the given organization you may need to specify TenantID.

## EXAMPLES

### Example 1

```powershell
Connect-ADOPS -Organization 'ADOPS'
```

Connect to an Azure DevOps organization interactively.

### Example 2

```powershell
Connect-ADOPS -ManagedIdentity -Organization 'ADOPS' -TenantId $TenantId
```

Connect to an Azure DevOps organization using a managed identity, specifying the tenant.

### Example 3

```powershell
Connect-ADOPS -OAuthToken $AccessToken -Organization 'ADOPS'
```

Connect to an Azure DevOps organization using an existing access token.

## PARAMETERS

### -Interactive

Connect to an Azure DevOps organization using an interactive browser login.

```yaml
Type: SwitchParameter
Parameter Sets: Interactive
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ManagedIdentity

Connect to an Azure DevOps organization using a managed identity.

```yaml
Type: SwitchParameter
Parameter Sets: ManagedIdentity
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OAuthToken

Connect to an Azure DevOps organization using an existing access token.

```yaml
Type: String
Parameter Sets: OAuthToken
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Organization

Name of the Azure DevOps organization.

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

Specify a tenant to connect to, by id.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
