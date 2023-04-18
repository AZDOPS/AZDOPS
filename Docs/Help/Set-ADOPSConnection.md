---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Set-ADOPSConnection

## SYNOPSIS
Changes connection properties of ADOPS connections.

## SYNTAX

```
Set-ADOPSConnection [[-DefaultOrganization] <String>] [<CommonParameters>]
```

## DESCRIPTION
This command changes settings of an ADOPS connection such as Default organization.

## EXAMPLES

### Example 1
```powershell
PS C:\> Set-ADOPSConnection -DefaultOrganization org1
```

This command will set org1 as the default organization for all ADOPS commands.
If no previous connection to an Azure DevOps organization has been done, it will initialize it.

## PARAMETERS

### -DefaultOrganization
Organization to set as default for all ADOPS commands.

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
