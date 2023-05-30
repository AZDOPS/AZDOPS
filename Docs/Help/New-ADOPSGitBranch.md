---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# New-ADOPSGitBranch

## SYNOPSIS
Create a new branch in a Azure DevOps git repo. 

## SYNTAX

```
New-ADOPSGitBranch [[-Organization] <String>] [-RepositoryId] <String> [-Project] <String>
 [-BranchName] <String> [-CommitId] <String> [<CommonParameters>]
```

## DESCRIPTION
This command creates a new branch in an Azure DevOps git repo without the need to clone the repo or have any git tools installed.
It creates the branch from the submitted commit id.

## EXAMPLES

### Example 1
```powershell
PS C:\> New-ADOPSGitBranch -RepositoryId 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' -Project 'MyProj' -BranchName 'NewBranch' -CommitId '12345678910111213141516171819202122232425'
```

This will create a new branch in the repository with id 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' from the commit with id '12345678910111213141516171819202122232425' with name 'NewBranch'

### Example 2
```powershell
PS C:\> $Project = 'myProject'
PS C:\> $RepoName = 'myRepo'
PS C:\> $BranchName = 'NewBranch'
PS C:\> $repo = Get-ADOPSRepository -Project $Project -Repository $RepoName
PS C:\> $AllCommits = Invoke-ADOPSRestMethod -Uri $repo._links.commits.href -Method Get | Select-Object -ExpandProperty value 
PS C:\> $LatestCommit = ($AllCommits | Sort-Object -Property @{Expression = {$_.author.date}} -Descending | Select-Object -First 1).commitId
PS C:\> New-ADOPSGitBranch -RepositoryId $repo.id -Project $Project -BranchName $BranchName -CommitId $CommitId
```

This command shows how to get all git history directly from a repository using the `Invoke-ADOPSRestMethod` command and use this to create a new branch from the latest commit. 

## PARAMETERS

### -BranchName
Name of the new branch to create

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

### -CommitId
Full hash commit id to use as base of the new branch.
This can be found using `Invoke-ADOPSRestMethod` (see example), or by running the command `git log -1 --format=format:"%H"` inside a git repository.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Organization
The organization to connect to

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
The project where the repository is located

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

### -RepositoryId
The ID of the repository in GUID format.
This can be found using the `Get-ADOPSRepository` command

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
