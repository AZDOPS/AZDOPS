---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Grant-ADOPSPipelinePermission

## SYNOPSIS
Grants pipeline permission to a resource of type VariableGroup, Queue, SecureFile, or Environment.

## SYNTAX

### SinglePipeline
```
Grant-ADOPSPipelinePermission -Project <String> -PipelineId <Int32> -ResourceType <ResourceType>
 -ResourceId <String> [-Organization <String>] [<CommonParameters>]
```

### AllPipelines
```
Grant-ADOPSPipelinePermission -Project <String> [-AllPipelines] -ResourceType <ResourceType>
 -ResourceId <String> [-Organization <String>] [<CommonParameters>]
```

## DESCRIPTION
Grants pipeline permissions to a resource of type VariableGroup, Queue, SecureFile, or Environment.
Specify a PipelineId to grant permissions to a single pipeline, or use the AllPipelines parameter to grant permissions to all pipelines.

## EXAMPLES

### Example 1
```powershell
PS C:\> Grant-ADOPSPipelinePermission -Pipeline 42 -ResourceType SecureFile -ResourceId '88d047be-7e59-4eda-b1fe-1614c7a69e16' -Project 'MyProject'
```

Grant pipeline 42 permission to the secure file with id 88d047be-7e59-4eda-b1fe-1614c7a69e16 in project MyProject.

## PARAMETERS

### -AllPipelines
Grant access for all pipelines. This is equivalent to disable the restrictions on the resource.

```yaml
Type: SwitchParameter
Parameter Sets: AllPipelines
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Organization
Name of the Azure DevOps organization. Defaults to the current organization.

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

### -PipelineId
Id of the pipeline to grant permissions for.

```yaml
Type: Int32
Parameter Sets: SinglePipeline
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Project
Name of project containing the resource.


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

### -ResourceId
Id of the resource to grant permissions to.

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

### -ResourceType
Resource type to grant permissions to. Valid values are VariableGroup, Queue, SecureFile, and Environment.

```yaml
Type: ResourceType
Parameter Sets: (All)
Aliases:
Accepted values: VariableGroup, Queue, SecureFile, Environment

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
## NOTES

## RELATED LINKS
