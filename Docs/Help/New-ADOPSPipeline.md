---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# New-ADOPSPipeline

## SYNOPSIS
Create a new pipeline from a existing yaml file in your repository.

## SYNTAX

```
New-ADOPSPipeline [-Name] <String> [-Project] <String> [-YamlPath] <String> [-Repository] <String>
 [[-FolderPath] <String>] [[-Organization] <String>] [<CommonParameters>]
```

## DESCRIPTION
Create a new pipeline from a existing yaml file in your repository.

## EXAMPLES

### Example 1
```powershell
PS C:\> New-ADOPSPipeline -Name $PipelineName -Project $ProjectName -YamlPath 'pipelines/pipeline1.yaml' -Repository $RepositoryName -Organization $OrganizationName
```

Create pipeline in $ProjectName

### Example 2
```powershell
PS C:\> New-ADOPSPipeline -Name $PipelineName -Project $ProjectName -YamlPath 'pipelines/pipeline1.yaml' -Repository $RepositoryName -FolderPath 'folder1\folder2'
```

Create pipeline in $ProjectName and use Default Organization and put the pipeline in subfolder folder2 under DevOps Pipelines.

## PARAMETERS

### -Name
Name of the pipeline. 

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
The organization to add pipeline to.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FolderPath
Folderpath to add your pipelines to under Devops Pipelines.
Like: PipelineFolder or PipelineFolder1\PipelineSubFolder2

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Project
The project to add the pipeline to.

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

### -Repository
The Repository Name where the Pipeline Yaml file is located.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -YamlPath
The path to the Yaml file in your repository.
Like: File.yaml or Folder/Folder/File.yaml

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
