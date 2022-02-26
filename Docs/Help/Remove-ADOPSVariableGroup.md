---
external help file: AZDOPS-help.xml
Module Name: AZDOPS
online version:
schema: 2.0.0
---

# Remove-AZDOPSVariableGroup

## SYNOPSIS

Removes a variable group from Azure DevOps.

## SYNTAX

```powershell
Remove-AZDOPSVariableGroup [[-Organization] <String>] [-Project] <String> [-VariableGroupName] <String>
 [<CommonParameters>]
```

## DESCRIPTION

Removes a variable group from Azure DevOps.

## EXAMPLES

### Example 1

```powershell
Remove-AZDOPSVariableGroup -Organization 'azdops' -Project 'azdopsproj' -VariableGroupName 'ExampleVarGroup'
```

Removes the variable group called "ExampleVarGroup" from the project "azdopsproj" in the organization "azdops".

### Example 2

```powershell
Remove-AZDOPSVariableGroup -Project 'azdopsproj' -VariableGroupName 'ExampleVarGroup'
```

Removes the variable group called "ExampleVarGroup" from the project "azdopsproj" in the default organization.

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
