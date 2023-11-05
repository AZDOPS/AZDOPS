---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Set-ADOPSPipelineSettings

## SYNOPSIS
Sets specific pipeline setting or set multiple pipeline settings.

## SYNTAX

### Values
```
Set-ADOPSPipelineSettings [-Organization <String>] [-Project <String>] -Values <Object> [<CommonParameters>]
```

### Value
```
Set-ADOPSPipelineSettings [-Organization <String>] [-Project <String>] -Name <String> -Value <Boolean>
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> Set-ADOPSPipelineSettings -Project 'MyProject' -Name 'statusBadgesArePrivate' -Value $false
```

This command will return a value for specific setting with the name `statusBadgesArePrivate`

### Example 2
```powershell
PS C:\> Set-ADOPSPipelineSettings -Project 'MyProject' -Values @{
    statusBadgesArePrivate = $false
    disableImpliedYAMLCiTrigger = $true
}
```

## PARAMETERS

### -Name

Name of the pipeline setting. Exact matches, no wildcards.

```yaml
Type: String
Parameter Sets: Value
Aliases:

Required: True
Position: Named
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

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Value
Value of the pipeline setting.

```yaml
Type: Boolean
Parameter Sets: Value
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Values
Multiple pipeline settings to set.

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

A key/value custom object of all pipeline settings is returned even when the name parameter is passed..

## NOTES

## RELATED LINKS
