---
external help file:
Module Name:
online version:
schema: 2.0.0
---

# Get-ADOPSResourceUsage

## SYNOPSIS
Gets all resource usage limits in an Azure DevOps organization.

## SYNTAX

```
Get-ADOPSResourceUsage [[-Organization] <String>] [<CommonParameters>]
```

## DESCRIPTION
Gets all resource usage limits in an Azure DevOps organization.
If the module is loaded without AllowInsecureApis parameter or the variable AdopsAllowInsecureApis set, Use -Force to run command.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-ADOPSResourceUsage
```

Gets all resource usage limits in an Azure DevOps organization.

## PARAMETERS

### -Organization
The organization to get resource usage from.

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
