---
external help file: AZDOPS-help.xml
Module Name: AZDOPS
online version:
schema: 2.0.0
---

# New-AZDOPSUserStory

## SYNOPSIS
Create User Story in DevOps Project

## SYNTAX

```
New-AZDOPSUserStory -Organization <String> -ProjectName <String> -Title <String> [-Description <String>]
 [-Tags <String>] [-Priority <String>] [<CommonParameters>]
```

## DESCRIPTION
Creates a User Story (Work Item) in an Azure DevOps Project.

## EXAMPLES

### Example 1
```powershell
New-AZDOPSUserStory -Organization 'myOrganization' -ProjectName 'myProject' -Title 'My user story' -Description 'User story description' -Tags 'AZDOPS' -Priority 1
```

Creates a user story with the title 'My user story' in the DevOps Project 'myProject'.

### Example 2
```powershell
New-AZDOPSUserStory -Organization 'myOrganization' -ProjectName 'myProject' -Title 'My user story' -Description 'User story description' -Tags 'AZDOPS,Important' -Priority 1
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
Position: Named
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

Required: True
Position: Named
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
Position: Named
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
Position: Named
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
Position: Named
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
