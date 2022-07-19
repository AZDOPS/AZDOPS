---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Test-ADOPSYamlFile

## SYNOPSIS
Test a yaml file against the Azure DevOps schema validator.

## SYNTAX

```
Test-ADOPSYamlFile [[-Organization] <String>] [-Project] <String> [-File] <String> [-PipelineId] <Int32>
 [<CommonParameters>]
```

## DESCRIPTION
This command will test a yaml file against the yaml validation schema in Azure DevOps.
It uses the same validation as the built in Azure DevOps yaml editor.
The command needs a pipeline id to run against, but will not replace any code in the pipeline.
False positives are possible if you use nested or external repos in your yaml code for example by using templates.

## EXAMPLES

### Example 1

```powershell
PS C:\> Test-ADOPSYamlFile -Project MyProject -File C:\GoodYamlFile.yml -PipelineId 3
```

This command will validate "C:\GoodYamlFile" against pipeline id 3 in the "MyProject" project.

## PARAMETERS

### -File
Path to the .yaml or .yml file

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
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PipelineId
Pipeline Id to run the verification against. 
Can be found by running the command

```PowerShell
Get-ADOPSPipeline -Project MyProject -Name MyPipelineName
```

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Project
The name of the project where the pipeline is.

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
