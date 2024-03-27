---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Get-ADOPSArtifactFeed

## SYNOPSIS
Gets one or more artifact feeds

## SYNTAX

### All (Default)
```
Get-ADOPSArtifactFeed [-Project <String>] [-Organization <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### FeedId
```
Get-ADOPSArtifactFeed -Project <String> [-Organization <String>] -FeedId <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This command gets one or more artifact feeds. 
If a project is given returns project scoped feeds. If no project is given it returns organization and project scoped feeds.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-ADOPSArtifactFeed
```

This command returns the all feeds in the organization.

### Example 2
```powershell
PS C:\> Get-ADOPSArtifactFeed -Project 'MyProject' -FeedId '222cc2c2-2cc2-222c-c2c2-c22cc222222c'
```

This command returns the feed with feed id '222cc2c2-2cc2-222c-c2c2-c22cc222222c'


## PARAMETERS

### -FeedId
Id of feed to get. GUID format.

```yaml
Type: String
Parameter Sets: FeedId
Aliases:

Required: True
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

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Project
Project to get feed(s) from

```yaml
Type: String
Parameter Sets: All
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: FeedId
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
