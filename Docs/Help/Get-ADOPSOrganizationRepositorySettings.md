---
external help file:
Module Name:
online version:
schema: 2.0.0
---

# Get-ADOPSOrganizationRepositorySettings

## SYNOPSIS
Get Azure DevOps Organization wide Repository settings

## SYNTAX

```
Get-ADOPSOrganizationRepositorySettings [[-Organization] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Get Azure DevOps Organization wide Repository settings
If the module is loaded without AllowInsecureApis parameter or the variable AdopsAllowInsecureApis set, Use -Force to run command.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-ADOPSOrganizationRepositorySettings
```

Get Azure DevOps Organization wide Repository settings

## PARAMETERS

### -Organization
The organization to get the repository settings from.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
