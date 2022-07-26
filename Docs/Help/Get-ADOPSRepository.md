---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Get-ADOPSRepository

## SYNOPSIS

Gets one or more repositories from a project in Azure DevOps.

## SYNTAX

```
Get-ADOPSRepository [-Project] <String> [[-Repository] <String>] [[-Organization] <String>]
 [<CommonParameters>]
```

## DESCRIPTION

Gets one or more repositories from a project in Azure DevOps.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-ADOPSRepository -Organization 'ADOPS' -Project 'ADOPSproj'
```

Gets all repositories from the project "ADOPSproj" in the organization "ADOPS".

### Example 2

```powershell
PS C:\> Get-ADOPSRepository -Project 'ADOPSproj' -Repository 'ADOPSrepo'
```

Gets the repository "ADOPSrepo" from the project "ADOPSproj", from the organization set as default amongst the established Azure DevOps connections.

## PARAMETERS

### -Organization

The organization to get repositories from.

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

The project to get repositories from.

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

### -Repository

The repository to get.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
