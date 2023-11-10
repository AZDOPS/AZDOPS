---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Get-ADOPSPipelineSettings

## SYNOPSIS

Returns all or specific pipeline setting.

## SYNTAX

```
Get-ADOPSPipelineSettings [[-Organization] <String>] -Project <String> 
 [<CommonParameters>]
```

## DESCRIPTION

This command will return a single pipeline setting available in your Azure DevOps Project.
If no parameters is given it will return all settings for Pipelines in a Azure DevOps Project.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-ADOPSPipelineSettings -Project 'MyProject'

enforceReferencedRepoScopedToken                  : True
disableClassicPipelineCreation                    : True
disableClassicBuildPipelineCreation               : True
disableClassicReleasePipelineCreation             : True
forkProtectionEnabled                             : True
buildsEnabledForForks                             : True
enforceJobAuthScopeForForks                       : True
enforceNoAccessToSecretsFromForks                 : True
isCommentRequiredForPullRequest                   : True
requireCommentsForNonTeamMembersOnly              : False
requireCommentsForNonTeamMemberAndNonContributors : False
enableShellTasksArgsSanitizing                    : True
enableShellTasksArgsSanitizingAudit               : False
disableImpliedYAMLCiTrigger                       : True
statusBadgesArePrivate                            : True
enforceSettableVar                                : True
enforceJobAuthScope                               : True
enforceJobAuthScopeForReleases                    : True
publishPipelineMetadata                           : True
```

This command will return a value for specific setting with the name `statusBadgesArePrivate`

## PARAMETERS

### -Organization

The organization to get pipeline settings from

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

The project to get pipeline settings from.

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

A key/value custom object of all pipeline settings is returned.

## NOTES

## RELATED LINKS
