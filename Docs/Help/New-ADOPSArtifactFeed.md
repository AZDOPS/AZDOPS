---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# New-ADOPSArtifactFeed

## SYNOPSIS
This command creates a new artifact feed

## SYNTAX

```
New-ADOPSArtifactFeed [-Project] <String> [[-Organization] <String>] [-Name] <String> [[-Description] <String>]
 [-IncludeUpstream] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This command creates a new artifact feed. It will try to add the Project build account as contributor to the feed in order for builds to be able to automatically publish packages.
If -IncludeUpstream is set it will add all currently available upstreams. 

## EXAMPLES

### Example 1
```powershell
PS C:\> New-ADOPSArtifactFeed -Project 'MyProject' -Name 'MyNewFeed'
```

This command will add a new feed named `MyNewFeed` to the `MyProject` project. It will try to add the account `MyProject build service (ConnectedOrg)` as contributor. It will not enable upstreams.

### Example 1
```powershell
PS C:\> New-ADOPSArtifactFeed -Project 'MyProject' -Name 'MyNewFeed' -IncludeUpstreams
```

This command will add a new feed named `MyNewFeed` to the `MyProject` project. It will try to add the account `MyProject build service (ConnectedOrg)` as contributor. It will enable upstreams and add all currently available sources.

## PARAMETERS

### -Description
Add a description to the feed description field.

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

### -IncludeUpstream
Enable upstreams and add all currently available upstreams

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

### -Name
Feed name

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
Project in which the feed will be created.

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
