---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Set-ADOPSArtifactFeed

## SYNOPSIS
Changes a setting for an artifact feed.

## SYNTAX

```
Set-ADOPSArtifactFeed [-Project] <String> [[-Organization] <String>] [-FeedId] <String>
 [[-Description] <String>] [[-UpstreamEnabled] <Boolean>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Changes a setting for an artifact feed. Currently only supports Description and enabling or disabling upstreams.

## EXAMPLES

### Example 1
```powershell
PS C:\> $i = (Get-ADOPSArtifactFeed -Project 'MyProject' -FeedId 'MyCustomFeed').id
PS C:\> Set-ADOPSArtifactFeed -Project 'MyProject' -FeedId $i -Description 'Update the description' -UpstreamEnabled:$true
```

This command will set the description for artifact feed 'MyCustomFeed' in the 'MyProject' project. It will also enable upstreams and add all currently supported upstream sources.

## PARAMETERS

### -Description
Set the feed description

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

### -FeedId
Feed Id in gui format or name.

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
Name of the organization to use.

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

### -Project
Project where the feed is located

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

### -UpstreamEnabled
Enable or Disable upstreams. If enabling it will also add all current upstream sources.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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
