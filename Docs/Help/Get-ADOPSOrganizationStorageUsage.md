---
external help file:
Module Name:
online version:
schema: 2.0.0
---

# Get-ADOPSOrganizationStorageUsage

## SYNOPSIS
Get the Azure DevOps Organization Storage Usage

## SYNTAX

```
Get-ADOPSOrganizationStorageUsage [[-MeterId] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Get the Azure DevOps Organization Storage Usage


## EXAMPLES

### Example 1
```powershell
PS C:\> Get-ADOPSOrganizationStorageUsage
```

Get the Azure DevOps Organization Storage Usage using default MeterId

### Example 1
```powershell
PS C:\> Get-ADOPSOrganizationStorageUsage -MeterId '3efc2e47-d73e-4213-8368-3a8723ceb1cc'
```

Get the Azure DevOps Organization Storage Usage for MeterId '3efc2e47-d73e-4213-8368-3a8723ceb1cc'

## PARAMETERS

### -MeterId
The MeterId for Storage Usage.
Default value '3efc2e47-d73e-4213-8368-3a8723ceb1cc'

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: 3efc2e47-d73e-4213-8368-3a8723ceb1cc
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
