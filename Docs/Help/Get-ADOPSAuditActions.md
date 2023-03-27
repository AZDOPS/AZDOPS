---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Get-ADOPSAuditActions

## SYNOPSIS
Gets all actions that Azure DevOps can log.

## SYNTAX

```
Get-ADOPSAuditActions [[-Organization] <String>] [<CommonParameters>]
```

## DESCRIPTION
This commands lists all actions that Azure DevOps gets in the audit log.
https://learn.microsoft.com/en-us/azure/devops/organizations/audit/azure-devops-auditing?view=azure-devops&tabs=preview-page#review-audit-log

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-ADOPSAuditActions
```

This commands lists all actions that Azure DevOps gets in the audit log.

## PARAMETERS

### -Organization
The organization to get log data from.

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
