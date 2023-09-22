---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Set-ADOPSGitPermission

## SYNOPSIS
Sets git ref permissions on a Azure DevOps git repo

## SYNTAX

```
Set-ADOPSGitPermission [[-Organization] <String>] [-Project] <String> [-Repository] <String>
 [-Descriptor] <String> [[-Allow] <AccessLevels[]>] [[-Deny] <AccessLevels[]>] [<CommonParameters>]
```

## DESCRIPTION
This function sets Git ref access rights for a user or group in Azure DevOps. 
You may select the same rule for Allow and Deny, but it should not work and may lead to unexpected behaviours.

The following settings are possible to set.
bit 	name                    displayName
--- 	----                    -----------
1 		Administer              Administer
2 		GenericRead             Read
4 		GenericContribute       Contribute
8 		ForcePush               Force push (rewrite history and delete branches)
16 		CreateBranch            Create branch
32 		CreateTag               Create tag
64 		ManageNote              Manage notes
128 	PolicyExempt            Bypass policies when pushing
256 	CreateRepository        Create repository
512 	DeleteRepository        Delete repository
1024 	RenameRepository        Rename repository
2048 	EditPolicies            Edit policies
4096 	RemoveOthersLocks       Remove others' locks
8192 	ManagePermissions       Manage permissions
16384 	PullRequestContribute   Contribute to pull requests
32768 	PullRequestBypassPolicy Bypass policies when completing pull requests

## EXAMPLES

### Example 1
```powershell
PS C:\> $s = @{
    ProjectId = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' 
    RepositoryId = '11111111-1111-1111-1111-111111111111' 
    Descriptor = 'aad.AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'
    Allow = 'RenameRepository','ForcePush'
}
PS C:\> Set-ADOPSGitPermission @s
```

This command will grant the user with descriptor `aad.AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA` the force push, and rename repository rights on the repo with id `11111111-1111-1111-1111-111111111111`

### Example 2
```powershell
PS C:\> $s = @{
    ProjectId = Get-ADOPSProject MyProject | Select-Object -ExpandProperty id
    RepositoryId = Get-ADOPSRepository -Project $projectId -Repository MyRepo | Select-Object -ExpandProperty id
    Descriptor = Get-ADOPSUser -Name 'userEmail@domain.onmicrosoft.com' | Select-Object -ExpandProperty descriptor
    Allow = 6235
}
PS C:\> Set-ADOPSGitPermission @s
```

This command will grant the user `userEmail@domain.onmicrosoft.com` the 
Administer, GenericRead, ForcePush, CreateBranch, ManageNote, EditPolicies, RemoveOthersLocks
repository rights on the `MyRepo` repo

### Example 3
```powershell
PS C:\> $s = @{
    ProjectId = Get-ADOPSProject MyProject | Select-Object -ExpandProperty id
    RepositoryId = Get-ADOPSRepository -Project $projectId -Repository MyRepo | Select-Object -ExpandProperty id
    Descriptor = Get-ADOPSUser -Name 'userEmail@domain.onmicrosoft.com' | Select-Object -ExpandProperty descriptor
    Deny = Administer
}
PS C:\> Set-ADOPSGitPermission @s
```

This command will deny the user `userEmail@domain.onmicrosoft.com` the Administer repository rights on the `MyRepo` repo

## PARAMETERS

### -Allow
Enum of access rights to grant a user or group.
Can be either the topic or the value.

```yaml
Type: AccessLevels[]
Parameter Sets: (All)
Aliases:
Accepted values: Administer, GenericRead, GenericContribute, ForcePush, CreateBranch, CreateTag, ManageNote, PolicyExempt, CreateRepository, DeleteRepository, RenameRepository, EditPolicies, RemoveOthersLocks, ManagePermissions, PullRequestContribute, PullRequestBypassPolicy

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Deny
Enum of access rights to deny a user or group.
Can be either the topic or the value.

```yaml
Type: AccessLevels[]
Parameter Sets: (All)
Aliases:
Accepted values: Administer, GenericRead, GenericContribute, ForcePush, CreateBranch, CreateTag, ManageNote, PolicyExempt, CreateRepository, DeleteRepository, RenameRepository, EditPolicies, RemoveOthersLocks, ManagePermissions, PullRequestContribute, PullRequestBypassPolicy

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Descriptor
Descriptor of a user or group in Azure DevOps.
Can be found using the `Get-ADOPSUser` or `Get-ADOPSGroup` command. 

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
Name of the Azure DevOps organization.

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
Project ID or Project Name where the repo is located.

```yaml
Type: String
Parameter Sets: (All)
Aliases: ProjectId

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Repository
Repository ID or Repository Name to set access to.

```yaml
Type: String
Parameter Sets: (All)
Aliases: RepositoryId

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
