---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# New-ADOPSRepository

## SYNOPSIS
Create a new Azure DevOps Git repository

## SYNTAX

```
New-ADOPSRepository [-Name] <String> [-Project] <String> [[-Organization] <String>] [<CommonParameters>]
```

## DESCRIPTION
This command will create a new Git repository in your Azure DevOps project.

## EXAMPLES

### Example 1
```powershell
PS C:\> New-ADOPSRepository -Project 'MyProject' -Name 'MyNewRepo'
```

This command will add a new empty repo named 'MyNewRepo' in the MyProject project

## PARAMETERS

### -Name
The name of the new Git repo.

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

### -Organization
The organization in which the repo will be created.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Project
The project in which the repo will be created.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
