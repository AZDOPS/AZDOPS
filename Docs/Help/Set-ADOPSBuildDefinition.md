---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Set-ADOPSBuildDefinition

## SYNOPSIS
This command will update a build definition.

## SYNTAX

```
Set-ADOPSBuildDefinition [[-Organization] <String>] [-DefinitionObject] <Object>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This command will update a build definition. Because the build definition object is multilevel and intricate, and you _will_ need to have the correct definition revision and metadata, you _must_ use `Get-ADOPSBuildDefinition` and alter the output object.

## EXAMPLES

### Example 1
```powershell
PS C:\> $Definition = Get-ADOPSBuildDefinition -Project MyProject -Id 123
PS C:\> $Definition.queueStatus = 'disabled'
PS C:\> Set-ADOPSBuildDefinition -DefinitionObject $Definition
```

This command will set the build definition with id 123 to status 'disabled'

## PARAMETERS

### -DefinitionObject
Complete object returned from `Get-ADOPSBuildDefinition`

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Definition

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Organization
The organization to set definitions in.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
