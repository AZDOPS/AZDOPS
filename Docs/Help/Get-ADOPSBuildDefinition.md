---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Get-ADOPSBuildDefinition

## SYNOPSIS
This command gets one or more build definitions.

## SYNTAX

```
Get-ADOPSBuildDefinition [[-Organization] <String>] [-Project] <String> [[-Id] <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This command gets one or more build definitions. If will always return the full definition object in order for it to be used to update a definition. If no Id is given it will return all build definitions from the selected project.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-ADOPSBuildDefinition -Project myProject -Id 123
```

This command will return the build definition with id 123. If no definition id 123 is found it will throw an error.

### Example 2
```powershell
PS C:\> Get-ADOPSBuildDefinition -Project myProject
```

This command will return all build definitions in project myProject. If no definitions are found it will return an empty array.

### Example 3
```powershell
PS C:\> $Pipeline = Get-ADOPSPipeline -Project myProject -Name myPipeline
PS C:\> Get-ADOPSBuildDefinition -Project myProject -Id $Pipeline.id
```

This command will return the build definition of the pipeline named myPipeline.

## PARAMETERS

### -Id
build definition id to get.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Organization
The organization to get definitions from.

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
The project to get definition from.

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
## NOTES

## RELATED LINKS
