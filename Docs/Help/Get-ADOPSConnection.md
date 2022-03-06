---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Get-ADOPSConnection

## SYNOPSIS
Gets all established connections to Azure DevOps.

## SYNTAX

```
Get-ADOPSConnection [[-Organization] <String>] [<CommonParameters>]
```

## DESCRIPTION
This commands lists all established connections to Azure DevOps.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-ADOPSConnection

Name                           Value
----                           -----
MyOrganization                 {Credential, Default}
```

### Example 2
```powershell
PS C:\> Get-ADOPSConnection -Organization "MyOrganization"

Name                           Value
----                           -----
MyOrganization                 {Credential, Default}
```

## PARAMETERS

### -Organization
Lists a specific Organization connection.

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
