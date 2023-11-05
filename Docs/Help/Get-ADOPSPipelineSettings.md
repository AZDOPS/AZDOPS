---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Get-ADOPSPipelineSettings

## SYNOPSIS

Returns all or specific pipeline setting.

## SYNTAX

```
Get-ADOPSPipelineSettings [[-Organization] <String>] [-Project] <String> [[-Name] <String>]
 [<CommonParameters>]
```

## DESCRIPTION

This command will return a single pipeline setting available in your Azure DevOps Project.
If no parameters is given it will return all settings for Pipelines in a Azure DevOps Project.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-ADOPSPipelineSettings -Project 'MyProject' -Name 'statusBadgesArePrivate'
```

This command will return a value for specific setting with the name `statusBadgesArePrivate`

### Example 2

```powershell
PS C:\> Get-ADOPSPipelineSettings -Project 'MyProject'
```

This command will return all settings

## PARAMETERS

### -Name

Optional, name of the pipeline setting. Exact matches, no wildcards.

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

The organization to get pipeline settings from

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

The project to get pipeline settings from.

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

When pipeline setting name is passed, the return will be the settings value (probably a boolean).

When no pipeline setting name is passed, a key/value custom object is returned.

## NOTES

## RELATED LINKS
