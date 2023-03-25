---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Get-ADOPSGroup

## SYNOPSIS
Gets all Azure DevOps groups

## SYNTAX

```
Get-ADOPSGroup [[-Organization] <String>] [[-ContinuationToken] <String>] [<CommonParameters>]
```

## DESCRIPTION
This command returns all Azure DevOps groups in your organization.
It will not filter groups.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-ADOPSGroup
```

Gets all Azure DevOps groups

## PARAMETERS

### -ContinuationToken
Internal parameter. Used to get paged results

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Organization
The organization to get groups from.

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
