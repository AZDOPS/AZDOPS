---
external help file: AZDOPS-help.xml
Module Name: AZDOPS
online version:
schema: 2.0.0
---

# New-AZDOPSProject

## SYNOPSIS

Creates a new project in Azure DevOps.

## SYNTAX

```powershell
New-AZDOPSProject [-Name] <String> [[-Description] <String>] [-Visibility] <String>
 [[-SourceControlType] <String>] [[-ProcessTypeName] <String>] [[-Organization] <String>] [<CommonParameters>]
```

## DESCRIPTION

Creates a new project in Azure DevOps.

## EXAMPLES

### Example 1

```powershell
PS C:\> New-AZDOPSProject -Name 'azdopsproj' -Description 'an example project' -Visibility Public -Organization 'azdops'
```

Creates a new, public project called "azdopsproj" with a description in the organization "azdops".

### Example 2

```powershell
PS C:\> New-AZDOPSProject -Name 'azdopsproj' -Visibility Private -ProcessTypeName 'Agile'
```

Creates a new, private project called "azdopsproj" with the process type "Agile" in the default organization.

### Example 3

```powershell
PS C:\> New-AZDOPSProject -Name 'azdopsproj' -Visibility Private -ProcessTypeName 'MyOwnProcess' -SourceControlType 'Tfvc'
```

Creates a new, private project called "azdopsproj" with an existing, custom process type "MyOwnProcess" in the default organization, with the source control type set to Team Foundation Version Control.

## PARAMETERS

### -Name

The name of the new project.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description

The description of the new project.

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

The organization to create the project in.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Visibility

The visibility of the project.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Private, Public

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProcessTypeName

The name of a process to use in the project.

This can be the name of an existing process such as Basic, Agile, Scrum or CMMI. It can also be the name of a custom process created in the organization.

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

### -SourceControlType

The source control type to use in the project. The default is git.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Git, Tfvc

Required: False
Position: 3
Default value: Git
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
