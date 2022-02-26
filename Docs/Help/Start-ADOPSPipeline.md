---
external help file: AZDOPS-help.xml
Module Name: AZDOPS
online version:
schema: 2.0.0
---

# Start-AZDOPSPipeline

## SYNOPSIS
Starts an Azure DevOps Pipeline.

## SYNTAX

```
Start-AZDOPSPipeline [-Name] <String> [-Project] <String> [[-Organization] <String>] [[-Branch] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Starts an Azure DevOps Pipeline.

## EXAMPLES

### Example 1
```powershell
Start-AZDOPSPipeline -Name 'myPipeline' -Project 'myProject' -Organization 'AZDOPS' -Branch 'main'
```

Starts the DevOps Pipeline 'myPipeline' in the project 'myProject'.

## PARAMETERS

### -Branch
Name of the branch to use.

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

### -Name
Name of the DevOps Pipeline.

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

### -Organization
Name of the DevOps Organization

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
Name of the DevOps Project.

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
