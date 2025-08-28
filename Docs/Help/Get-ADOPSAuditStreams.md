---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Get-ADOPSAuditStreams

## SYNOPSIS
Gets all audit streams in an Azure DevOps organization.

## SYNTAX

```
Get-ADOPSAuditStreams [[-Organization] <String>] [<CommonParameters>]
```

## DESCRIPTION
This commands lists all audit streams in an Azure DevOps organization.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-ADOPSAuditStreams
```

This commands lists all audit streams in an Azure DevOps organization.

## PARAMETERS

### -Organization
The organization to get audit steams from.

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
