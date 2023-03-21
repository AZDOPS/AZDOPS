---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# New-ADOPSMergePolicy

## SYNOPSIS
This command sets the Limit merge types setting of a repository git branch.

## SYNTAX

```
New-ADOPSMergePolicy [-Project] <String> [[-Organization] <String>] [-RepositoryId] <String> [-Branch] <String>
 [-allowNoFastForward] [-allowSquash] [-allowRebase] [-allowRebaseMerge] [<CommonParameters>]
```

## DESCRIPTION
This setting creates and enables a merge restriction policy on a git branch on a Azure DevOps repository.
It will allow only those merge types activated.

WARNING: It is possible to allow no merge types at all, effectively preventing any code from being merged to a repository.
Make sure to activate at least one policy.

## EXAMPLES

### Example 1
```powershell
PS C:\> New-ADOPSMergePolicy -Project 'MyProject' -RepositoryId 62a7c071-1a60-44a9-a151-d17cd4d367da -Branch 'main'-allowSquash
```

This command will create a merge policy only allowing squash merges to the main branch of the repository with id 62a7c071-1a60-44a9-a151-d17cd4d367da

### Example 2
```powershell
PS C:\> $ADOPSProject = 'MyProject'
PS C:\> $RepoId = Get-ADOPSRepository -Project $ADOPSProject -Repository 'MyRepo' | Select-Object -ExpandProperty Id

PS C:\> New-ADOPSMergePolicy -Project $ADOPSProject -RepositoryId $RepoId -Branch 'refs/heads/main' -allowNoFastForward -allowSquash -allowRebase -allowRebaseMerge
```

This command will create a merge policy allowing any type of merges to the main branch of the repository MyRepo

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

### -allowNoFastForward
Enables basic merge (No fast forward)

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -allowRebase
Enables Rebase and fast-forward

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -allowRebaseMerge
Enables Rebase with merge commit

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -allowSquash
Enables Squash merge

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
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
