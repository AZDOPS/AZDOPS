---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Get-ADOPSOrganizationAdminOverview

## SYNOPSIS
Get the organization admin overview data.

## SYNTAX

```
Get-ADOPSOrganizationAdminOverview [[-Organization] <String>] [[-ContributionIds] <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Get the organization admin overview data.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-ADOPSOrganizationAdminOverview
```

Get the organization admin overview data.

## PARAMETERS

### -ContributionIds
List of contribution ids

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Organization
The identifier of the Azure DevOps organization.

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
