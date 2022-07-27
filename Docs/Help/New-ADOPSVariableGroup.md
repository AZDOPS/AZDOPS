---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# New-ADOPSVariableGroup

## SYNOPSIS

Creates a new variable group in an Azure DevOps project.

## SYNTAX

### VariableSingle
```
New-ADOPSVariableGroup -VariableGroupName <String> -VariableName <String> -VariableValue <String>
 -Project <String> [-IsSecret] [-Description <String>] [-Organization <String>] [<CommonParameters>]
```

### VariableHashtable
```
New-ADOPSVariableGroup -VariableGroupName <String> -Project <String> -VariableHashtable <Hashtable[]>
 [-Description <String>] [-Organization <String>] [<CommonParameters>]
```

## DESCRIPTION

Creates a new variable group in an Azure DevOps project.

The command only supports a single variable being created together with the variable group.

## EXAMPLES

### Example 1

```powershell
PS C:\> $Hashtable = @(
            @{
                Name     = "Key1"
                value    = "Key1Value"
                IsSecret = $true
            },
            @{
                Name     = "Key2"
                value    = "Key2Value"
                IsSecret = $false
            }
        )

PS C:\> New-ADOPSVariableGroup -Project 'ADOPSproj' -Organization 'ADOPS' -VariableGroupName 'ADOPSvars' -Description 'vargroup example' -VariableHashtable $Hashtable
```

Creates a new variable group called "ADOPSvars" in the project "ADOPSproj" in the organization "ADOPS" with a description, providing a hashtable to create one non-secret variable called "Key2" with the value "Key2Value" and one secret variable called "Key1" with the value "Key1Value".

### Example 2

```powershell
PS C:\> New-ADOPSVariableGroup -Project 'ADOPSproj' -VariableGroupName 'ADOPSvars' -VariableName 'var-name' -VariableValue 'var-value'
```

Creates a new variable group called "ADOPSvars" in the project "ADOPSproj" in the default organization, creating a variable called "var-name" with the value "var-value".

## PARAMETERS

### -Description

The description of the variable group.

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

### -IsSecret

Whether or not the variable created should be considered a secret.

```yaml
Type: SwitchParameter
Parameter Sets: VariableSingle
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Organization

The organization of the project to create the variable group in.

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

The name of the project to create the variable group in.

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

### -VariableGroupName

The name of the new variable group.

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

### -VariableHashtable

A hashtable containing the variable to be created with the variable group.



@(
    @{
        Name     = "Key1"
        value    = "Key1Value"
        IsSecret = $true
    },
    @{
        Name     = "Key2"
        value    = "Key2Value"
        IsSecret = $false
    }
)

```yaml
Type: Hashtable[]
Parameter Sets: VariableHashtable
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -VariableName

The name of the variable to be created with the variable group.

```yaml
Type: String
Parameter Sets: VariableSingle
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -VariableValue

The value of the variable to be created with the variable group.

```yaml
Type: String
Parameter Sets: VariableSingle
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
