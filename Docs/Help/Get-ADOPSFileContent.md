---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Get-ADOPSFileContent

## SYNOPSIS
Gets the content of a single file in an Azure DevOps repository.

## SYNTAX

```
Get-ADOPSFileContent [[-Organization] <String>] [-Project] <String> [-RepositoryId] <String>
 [-FilePath] <String> [<CommonParameters>]
```

## DESCRIPTION
This command gets the contents of a file in an Azure DevOps repository
It will try to get the contents no matter the file type, and may fail if a binary or otherwise unreadable file is given.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-ADOPSFileContent -Project MyProject -RepositoryId a1c93080-9d68-4ab9-95cf-1a5f68740628 -FilePath /MyFile.ps1
```

This command will return the contents of the file "MyFile.ps1" located in the root of the repository "a1c93080-9d68-4ab9-95cf-1a5f68740628" in the "MyProject" project of your default logged in organization.

## PARAMETERS

### -FilePath
Full path to the file which contents are read.

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
The organization where the repository is located

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
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RepositoryId
The id (GUID) of the repository.
This can be found using the command
Get-ADOPSRepository -Project ProjectName -Repository RepositoryName | Select-Object -ExpandProperty id

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
