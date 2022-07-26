---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# New-ADOPSUserStory

## SYNOPSIS
Create User Story in DevOps Project

## SYNTAX

```
New-ADOPSUserStory [-Title] <String> [-ProjectName] <String> [[-Description] <String>] [[-Tags] <String>]
 [[-Priority] <String>] [[-Organization] <String>] [<CommonParameters>]
```

## DESCRIPTION
Creates a User Story (Work Item) in an Azure DevOps Project.

## EXAMPLES

### Example 1
```powershell
New-ADOPSUserStory -Organization 'myOrganization' -ProjectName 'myProject' -Title 'My user story' -Description 'User story description' -Tags 'ADOPS' -Priority 1
```

Creates a user story with the title 'My user story' in the DevOps Project 'myProject'.

### Example 2
```powershell
New-ADOPSUserStory -Organization 'myOrganization' -ProjectName 'myProject' -Title 'My user story' -Description 'User story description' -Tags 'ADOPS,Important' -Priority 1
```

Creates a user story with multiple tags.

## PARAMETERS

### -Description
Description text for the User Story work item.

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

### -Organization
Name of the organization to use.

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

### -Priority
User Story priority.

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

### -ProjectName
Name of the DevOps project to use.

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

### -Tags
Tags to use for the user story. Multiple tags can be added and separated by comma.

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

### -Title
Title of the User Story.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
