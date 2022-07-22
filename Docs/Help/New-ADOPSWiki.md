---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# New-ADOPSWiki

## SYNOPSIS

Creates a new Azure DevOps code wiki.

## SYNTAX

```
New-ADOPSWiki [[-Organization] <String>] [-Project] <String> [-WikiName] <String> [-WikiRepository] <String>
 [[-WikiRepositoryPath] <String>] [[-GitBranch] <String>] [<CommonParameters>]
```

## DESCRIPTION

This command lets you create a new Azure DevOps code wiki.
This wiki is editable by changing markdown files directly in a repository in your Azure DevOps project.

## EXAMPLES

### Example 1

```powershell
PS C:\> New-ADOPSWiki -Project 'myproject' -WikiName 'MyWikiName' -WikiRepository 'MyWikiRepo'
```

This command will create a new wiki named "MyWikiName", in the "MyProject" project in your current default logged in Azure DevOps environment.
It will store the markdown files in the "MyWikiRepo" repository, using the root folder in the main branch.

### Example 2

```powershell
PS C:\> New-ADOPSWiki -Project 'myproject' -WikiName 'MyWikiName' -WikiRepository 'MyWikiRepo' -WikiRepositoryPath '/MyWikiFiles' -GitBranch 'PublicWiki'
```

This command will create a new wiki named "MyWikiName", in the "MyProject" project in your current default logged in Azure DevOps environment.
It will store the markdown files in the "MyWikiRepo" repository.
The Markdown files will be stored in the "/MyWikiFiles" subfolder of the repository.
The wiki will be published from the "PublicWiki" branch of the "MyWikiRepo" repository.

## PARAMETERS

### -GitBranch

The git branch used for wiki markdown pages.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: Main
Accept pipeline input: False
Accept wildcard characters: False
```

### -Organization

Name of the organization to use.

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

The project in which to create the wiki.

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

### -WikiName

Name of the wiki.

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

### -WikiRepository

The Git repository that will host the markdown wiki files.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WikiRepositoryPath

Path relative to the root where the wiki home will be.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: '/'
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
