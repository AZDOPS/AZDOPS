---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Get-ADOPSWiki

## SYNOPSIS
Gets one or more wikis from a Azure DevOps project

## SYNTAX

```
Get-ADOPSWiki [[-Organization] <String>] [-Project] <String> [[-WikiId] <String>] [<CommonParameters>]
```

## DESCRIPTION
This command returns Azure DevOPs wikis from a project.
If a wiki name is given it will return any wikis with that exact name.
Wildcards are _not_ supported.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-ADOPSWiki -Project MyProject -WikiId MyProject.wiki
```

This command will return the MyProject.wiki wiki from the MyProject project.
If no MyProjet.wiki exists it will return nothing.

### Example 2
```powershell
PS C:\> Get-ADOPSWiki -Project MyProject
```

This command will return all wikis from the MyProject project.

## PARAMETERS

### -Organization
The organization to get wikis from.

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
The project to get wiki(s) from

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

### -WikiId
Name or ID of a specific wiki to return.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
