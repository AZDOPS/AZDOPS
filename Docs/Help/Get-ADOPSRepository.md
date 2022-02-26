---
external help file: AZDOPS-help.xml
Module Name: AZDOPS
online version:
schema: 2.0.0
---

# Get-AZDOPSRepository

## SYNOPSIS

Gets one or more repositories from a project in Azure DevOps.

## SYNTAX

```powershell
Get-AZDOPSRepository [[-Organization] <String>] [-Project] <String> [[-Repository] <String>]
 [<CommonParameters>]
```

## DESCRIPTION

Gets one or more repositories from a project in Azure DevOps.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-AZDOPSRepository -Organization 'azdops' -Project 'azdopsproj'
```

Gets all repositories from the project "azdopsproj" in the organization "azdops".

### Example 2

```powershell
PS C:\> Get-AZDOPSRepository -Project 'azdopsproj' -Repository 'azdopsrepo'
```

Gets the repository "azdopsrepo" from the project "azdopsproj", from the organization set as default amongst the established Azure DevOps connections.

## PARAMETERS

### -Organization

The organization to get repositories from.

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

The project to get repositories from.

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

### -Repository

The repository to get.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
