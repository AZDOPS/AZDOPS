---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Set-ADOPSPipelineSettings

## SYNOPSIS
Set pipeline settings for a project.

## SYNTAX

### Values
```
Set-ADOPSPipelineSettings [-Organization <String>] -Project <String> -Values <Object> [<CommonParameters>]
```


## DESCRIPTION
This command will set pipeline settings for a project.

## EXAMPLES

### Example 1
```powershell
PS C:\> Set-ADOPSPipelineSettings -Project 'MyProject' -Values @{
    statusBadgesArePrivate
}
```

This command will set a single setting `statusBadgesArePrivate`

### Example 2
```powershell
PS C:\> Set-ADOPSPipelineSettings -Project 'MyProject' -Values @{
    statusBadgesArePrivate = $false
    disableImpliedYAMLCiTrigger = $true
}
```

This command will set multiple settings

## PARAMETERS


### -Organization
The organization to get pipeline settings from.

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
The project to get pipeline settings from.

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

### -Values
Pipeline settings to set.

```yaml
Type: Object
Parameter Sets: Values
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

A key/value custom object of all pipeline settings is returned.

## NOTES

## RELATED LINKS
