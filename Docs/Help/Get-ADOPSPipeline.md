---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Get-ADOPSPipeline

## SYNOPSIS

Get a specific pipeline or all pipelines in a specific DevOps project.

## SYNTAX

```
Get-ADOPSPipeline [[-Name] <String>] [-Project] <String> [[-Organization] <String>] [<CommonParameters>]
```

## DESCRIPTION

Lists a specific Pipeline or all Pipelines in a Specific Project.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-ADOPSPipeline -Organization $OrganizationName -Project $Project -Name $Name
```

Get pipeline with name $Name from $Project.

### Example 2

```powershell
PS C:\> Get-ADOPSPipeline -Organization $OrganizationName -Project $Project
```

List all Pipelines in $Project

### Example 3

```powershell
PS C:\> Get-ADOPSPipeline -Project $Project
```

List all Pipelines in $Project and uses Default Organization.

## PARAMETERS

### -Name

Name of the pipeline.

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

### -Organization

The organization to get pipeline/s from.

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

### -Project

The project to get pilepine/s from.

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
