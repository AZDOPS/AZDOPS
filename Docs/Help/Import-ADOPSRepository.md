---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Import-ADOPSRepository

## SYNOPSIS
Import an external public git repo to Azure DevOps repos.

## SYNTAX

### RepositoryName (Default)
```
Import-ADOPSRepository -GitSource <String> -RepositoryName <String> -Project <String> [-Organization <String>]
 [<CommonParameters>]
```

### RepositoryId
```
Import-ADOPSRepository -GitSource <String> -RepositoryId <String> -Project <String> [-Organization <String>]
 [<CommonParameters>]
```

## DESCRIPTION
This command will import any public git repo using http or https git link.
It requires a precreated empty git repo target. You van assign the target using repository name or repository Id

## EXAMPLES

### Example 1
```powershell
PS C:\> Import-ADOPSRepository -Project MyProject -GitSource https://github.com/AZDOPS/AZDOPS.git -RepositoryName MyLocalRepo
```

This command will import all data from the `https://github.com/AZDOPS/AZDOPS.git` repo to the local Azure DevOps repo `MyLocalRepo`

## PARAMETERS

### -GitSource
The source repo to fetch. Must be a public accessable http or https link.

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

### -Organization
Your Azure DevOps organization.

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

### -Project
The Azure DevOps project where your local repo exists.

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

### -RepositoryId
Repository id where to import the GitSource.
This must be an empty Azure DevOps repository.

```yaml
Type: String
Parameter Sets: RepositoryId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RepositoryName
Repository name where to import the GitSource.
This must be an empty Azure DevOps repository.

```yaml
Type: String
Parameter Sets: RepositoryName
Aliases:

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
