---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Set-ADOPSRepository

## SYNOPSIS
Changes or updates repository settings

## SYNTAX

```
Set-ADOPSRepository [-RepositoryId] <String> [-Project] <String> [[-Organization] <String>]
 [[-DefaultBranch] <String>] [[-IsDisabled] <Boolean>] [[-NewName] <String>] [<CommonParameters>]
```

## DESCRIPTION
This command changes or updates one or more repository settings.
It can change one or all settings in one call.
It will not ask for confirmation before updating or changing a value.

## EXAMPLES

### Example 1
```powershell
PS C:\> Set-ADOPSRepository -IsDisabled:$true -Project 'DummyProj' -RepositoryId 'd5f24968-f2ab-4048-bd65-58711420f6fa'
```

This will set the repository with id d5f24968-f2ab-4048-bd65-58711420f6fa to status disabled.
This repo will not be possible to work from after this action.

### Example 2
```powershell
PS C:\> Set-ADOPSRepository -NewName 'NewName'-Project 'DummyProj' -RepositoryId 'd5f24968-f2ab-4048-bd65-58711420f6fa'
```

This will rename the repository with id d5f24968-f2ab-4048-bd65-58711420f6fa to 'NewName'.

### Example 2
```powershell
PS C:\> Set-ADOPSRepository -DefaultBranch 'defBranch' -Project 'DummyProj' -RepositoryId 'd5f24968-f2ab-4048-bd65-58711420f6fa'
```

This will set the default branch of the repository with id d5f24968-f2ab-4048-bd65-58711420f6fa to 'refs/heads/defBranch'.
If only branch name is given it will automatically add 'refs/heads/' to the branch path.

### Example 2
```powershell
PS C:\> Set-ADOPSRepository -IsDisabled:$false -NewName 'NewName' -DefaultBranch 'refs/heads/NewBranch' -Project 'DummyProj' -RepositoryId 'd5f24968-f2ab-4048-bd65-58711420f6fa'
```

This willperform all of the following actions on the repository with id d5f24968-f2ab-4048-bd65-58711420f6fa:
- Set status to enabled.
- Rename the repository to 'NewName'
- set the default branch to 'refs/heads/NewBranch'

## PARAMETERS

### -DefaultBranch
Sets the default branch to this value. If only branch name is given it will automatically add 'refs/heads/' to the path.

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

### -IsDisabled
Sets the isDisabled flag of the repository to true or false.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewName
Renames the directory to this name

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

### -Organization
The organization in which the repositoryID exists.

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
The project in which the repositoryID exists.

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

### -RepositoryId
Repository ID. This can be found using Get-ADOPSRepository -Project MyProject

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
