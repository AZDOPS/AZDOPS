---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Remove-ADOPSVariableGroup

## SYNOPSIS

Removes a variable group from Azure DevOps.

## SYNTAX

```powershell
Remove-ADOPSVariableGroup [[-Organization] <String>] [-Project] <String> [-VariableGroupName] <String>
 [<CommonParameters>]
```

## DESCRIPTION

Removes a variable group from Azure DevOps.

## EXAMPLES

### Example 1

```powershell
Remove-ADOPSVariableGroup -Organization 'ADOPS' -Project 'ADOPSproj' -VariableGroupName 'ExampleVarGroup'
```

Removes the variable group called "ExampleVarGroup" from the project "ADOPSproj" in the organization "ADOPS".

### Example 2

```powershell
Remove-ADOPSVariableGroup -Project 'ADOPSproj' -VariableGroupName 'ExampleVarGroup'
```

Removes the variable group called "ExampleVarGroup" from the project "ADOPSproj" in the default organization.

## PARAMETERS

### -Organization

Name of the Azure DevOps organization.

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

### -Project

Name of the Azure DevOps project.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -VariableGroupName

Name of the variable group to remove.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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
