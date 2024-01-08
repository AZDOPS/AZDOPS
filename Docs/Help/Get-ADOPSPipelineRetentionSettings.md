---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Get-ADOPSPipelineRetentionSettings

## SYNOPSIS

Returns all pipeline retention settings.

## SYNTAX

```
Get-ADOPSPipelineRetentionSettings [[-Organization] <String>] [-Project] <String> [<CommonParameters>]
```

## DESCRIPTION

This command will return all pipeline retention settings for a Azure DevOps Project.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-ADOPSPipelineRetentionSettings -Project 'MyProject'
```

This command will get all the pipeline retention settings values for a project.

## PARAMETERS

### -Organization

The organization to get pipeline retention settings from.

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

The project to get pipeline retention settings from.

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

A Key/value custom object of all the pipeline retention values.

## NOTES

## RELATED LINKS
