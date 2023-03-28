---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# New-ADOPSEnvironment

## SYNOPSIS
Creates a new environment and sets up a better default access rule to it.

## SYNTAX

```
New-ADOPSEnvironment [[-Organization] <String>] [-Project] <String> [-Name] <String> [[-Description] <String>]
 [[-AdminGroup] <String>] [-SkipAdmin] [<CommonParameters>]
```

## DESCRIPTION
This command creates a new environment in Azure DevOps.
It also adds an admin to it that is not the creator, in order to fix [this issue](https://developercommunity.visualstudio.com/t/Pipeline-environment-security-enhancemen/1236351?space=21&q=environment+permission&sort=votes&page=4)

It does not support adding resources to the created environment.

## EXAMPLES

### Example 1
```powershell
PS C:\> New-ADOPSEnvironment -Project 'myProject' -Name 'MyEnv'
```

This command will create an environment named 'MyEnv' in the 'MyProject' project.
It will add the '[myProject]\Project Administrators' group as administrator to the environment.

### Example 2
```powershell
PS C:\> New-ADOPSEnvironment -Project 'myProject' -Name 'MyEnv' -SkipAdmin
```

This command will create an environment named 'MyEnv' in the 'MyProject' project.
It will not add any group as administrator to the environment resulting in _only the user running the command_ having admin access to the environment (default behaviour)

### Example 3
```powershell
PS C:\> New-ADOPSEnvironment -Project 'myProject' -Name 'MyEnv' -Description 'MyEnvironment description' -AdminGroup '[myProject]\myProject Team'
```

This command will create an environment named 'MyEnv' with the description 'MyEnvironment description' in the 'MyProject' project.
It will also add the '[myProject]\myProject Team' group as administrator to the environment.

## PARAMETERS

### -AdminGroup
Custom group principalName to add as administrator in the environment.
Can be found using the `Get-ADOPSGroup` command. 

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Description of the environment

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Name of the environment
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

### -Organization
Organization to connect to

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
Project to create the environment in

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

### -SkipAdmin
Skip adding an administrative group.
This will lead to only the creator of the environment having administrative rights on the environment.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
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
