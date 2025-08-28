---
external help file:
Module Name:
online version:
schema: 2.0.0
---

# Get-ADOPSOrganizationPolicy

## SYNOPSIS

Gets all organization policy in selected category or all organization policies across all categories.

## SYNTAX

```
Get-ADOPSOrganizationPolicy [[-Organization] <String>] [[-PolicyCategory] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Gets all organization policy in selected category or all organization policies across all categories.
If the module is loaded without AllowInsecureApis parameter or the variable AdopsAllowInsecureApis set, Use -Force to run command.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-ADOPSOrganizationPolicy
```

Gets all organization policies in all categories

## PARAMETERS

### -Organization
The organization to get the policies from.

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
The selected policy category.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Security, Privacy, ApplicationConnection, User

Required: False
Position: 1
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
