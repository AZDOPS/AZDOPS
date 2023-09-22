---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Get-ADOPSVariableGroup

## SYNOPSIS
This command gets one or more variable groups from Azure DevOps.

## SYNTAX

### All (Default)
```
Get-ADOPSVariableGroup [-Organization <String>] -Project <String> [<CommonParameters>]
```

### Id
```
Get-ADOPSVariableGroup [-Organization <String>] -Project <String> [-Id <Int32>] [<CommonParameters>]
```

### Name
```
Get-ADOPSVariableGroup [-Organization <String>] -Project <String> [-Name <String>] [<CommonParameters>]
```

## DESCRIPTION
This command gets one or more variable groups from Azure DevOps. If no matching variable group is found it outputs nothing.
Searches can be done by Name or Id.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-ADOPSVariableGroup -Project MyAzureDevOpsProject
```

This command will return all variable groups in the MyAzureDevOpsProject project.

### Example 2
```powershell
PS C:\> Get-ADOPSVariableGroup -Project MyAzureDevOpsProject -Name MyVariableGroup
```

This command will return the "MyVariableGroup" variable group in the MyAzureDevOpsProject project.

### Example 3
```powershell
PS C:\> Get-ADOPSVariableGroup -Project MyAzureDevOpsProject -Id 4
```

This command will return the variable group with id 4 in the MyAzureDevOpsProject project.

## PARAMETERS

### -Id
Variable group id to search for.

```yaml
Type: Int32
Parameter Sets: Id
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Variable group name to search for.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Organization
Organization to search in.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Project
Project to search in.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
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
