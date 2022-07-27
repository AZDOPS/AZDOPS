---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Remove-ADOPSRepository

## SYNOPSIS
Deletes a repository from an Azure DevOps organization.

## SYNTAX

```
Remove-ADOPSRepository [-RepositoryID] <String> [-Project] <String> [[-Organization] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
This command deletes a repository from an Azure DevOps organization.

## EXAMPLES

### Example 1
```powershell
PS C:\> Remove-ADOPSRepository -Project MyProject -RepositoryID 1bb0b904-27b7-414d-811e-f51085e7ad02
```

This command will delete the repository with id '1bb0b904-27b7-414d-811e-f51085e7ad02' from the 'MyProject' project.

## PARAMETERS

### -Organization
The organization to connect to.

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
The project in which the repository exists.

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

### -RepositoryID
The repositoru ID, GUID, to delet.

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
