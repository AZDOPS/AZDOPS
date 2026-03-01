---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Get-ADOPSTenantPolicy

## SYNOPSIS

Gets one or all tenant policies for an Azure DevOps organization.

## SYNTAX

```
Get-ADOPSTenantPolicy [[-Organization] <String>] [[-PolicyCategory] <String>] [-Force]
 [<CommonParameters>]
```

## DESCRIPTION

Gets one or all tenant policies for an Azure DevOps organization.
When no PolicyCategory is specified, all supported policy categories are returned.
If the module is loaded without AllowInsecureApis parameter or the variable AdopsAllowInsecureApis set, Use -Force to run command.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-ADOPSTenantPolicy
```

Gets all tenant policies for the default organization.

### Example 2
```powershell
PS C:\> Get-ADOPSTenantPolicy -Organization 'MyOrganization' -PolicyCategory 'RestrictGlobalPersonalAccessToken'
```

Gets the RestrictGlobalPersonalAccessToken tenant policy for MyOrganization.

## PARAMETERS

### -Organization
The organization to get the tenant policy from.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PolicyCategory
The tenant policy category to retrieve. When omitted, all categories are returned.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: RestrictGlobalPersonalAccessToken, RestrictPersonalAccessTokenLifespan, EnableLeakedPersonalAccessTokenAutoRevocation, OrganizationCreationRestriction, RestrictFullScopePersonalAccessToken

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
Allows the cmdlet to run against unsupported Azure DevOps endpoints without enabling AllowInsecureApis globally.

```yaml
Type: SwitchParameter
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
