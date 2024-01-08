---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Set-ADOPSPipelineRetentionSettings

## SYNOPSIS

Set pipeline retention settings for a project.

## SYNTAX

```
Set-ADOPSPipelineRetentionSettings [[-Organization] <String>] [-Project] <String> [-Values] <Object>
 [<CommonParameters>]
```

## DESCRIPTION

This command will set the retention settings values for a project.

## EXAMPLES

### Example 1

```powershell
PS C:\> Set-ADOPSPipelineRetentionSettings -Project 'MyProject' -Values @{
    artifactsRetention = 51
    runRetention = 37
    pullRequestRunRetention = 4
    retainRunsPerProtectedBranch = 0
}
```

This command will set all pipeline retention settings.

### Example 2

```powershell
PS C:\> Set-ADOPSPipelineRetentionSettings -Project 'MyProject' -Values @{
    artifactsRetention = 51
}
```

This command will set a single pipeline retention settings.

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

### -Values

Pipeline retention settings to set.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
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

A Key/value custom object of all the pipeline retention value

## NOTES

## RELATED LINKS
