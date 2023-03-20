---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# New-ADOPSBuildPolicy

## SYNOPSIS
Creates a build validation policy for a repository

## SYNTAX

```
New-ADOPSBuildPolicy [-Project] <String> [[-Organization] <String>] [-RepositoryId] <String> [-Branch] <String>
 [-PipelineId] <Int32> [-Displayname] <String> [[-filenamePatterns] <String[]>] [<CommonParameters>]
```

## DESCRIPTION
This command creates a build validation policy for a repository.
It only creates the policy. You have to create the validation pipeline to be run manually.

## EXAMPLES

### Example 1
```powershell
PS C:\> New-ADOPSBuildPolicy -Project 'MyProject' -RepositoryId 62a7c071-1a60-44a9-a151-d17cd4d367da -Branch 'main' -PipelineId 1 -Displayname 'MyVerificationPolicy' -filenamePatterns '/root/*','/side/*'
```

This command will create a policy named `MyVerificationPolicy` on the repository with id `62a7c071-1a60-44a9-a151-d17cd4d367da` in the `MyProject` project, that triggers on branch `main`.
It will filter the validation to run only on changes in folder `/root/` or `/side/`.

### Example 2
```powershell
PS C:\> $ADOPSProject = 'MyProject'
PS C:\> $RepoId = Get-ADOPSRepository -Project $ADOPSProject -Repository 'MyRepo' | Select-Object -ExpandProperty Id
PS C:\> $PipelineId = Get-ADOPSPipeline -Project $ADOPSProject -Name 'MyPipeline' | Select-Object -ExpandProperty id

PS C:\> New-ADOPSBuildPolicy -Project $ADOPSProject -RepositoryId $RepoId -Branch 'refs/heads/main' -PipelineId $PipelineId -Displayname 'MyVerificationPolicy'
```

This command will create a policy named `MyVerificationPolicy` running the `MyPipeline` pipeline on the repository `MyRepo` in the `MyProject` project, that triggers on branch `main`.


## PARAMETERS

### -Branch
git branch to trigger on. Accepts both branch name ('main') or full git path ('refs/heads/main')
If only path name is given it will append "refs/heads/"

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

### -Displayname
Display name of the policy setting

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
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
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PipelineId
PipelineId, or build definition id.
Can be found using the `Get-ADOPSPipeline` command

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Project
Project where the pipeline and repository is located

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

### -RepositoryId
Id of the repository in which to create the policy.
Can be found using the `Get-ADOPSRepository` command

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

### -filenamePatterns
Filter validation trigger on repository path(s)

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
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
