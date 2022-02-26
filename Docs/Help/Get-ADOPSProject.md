---
external help file: AZDOPS-help.xml
Module Name: AZDOPS
online version:
schema: 2.0.0
---

# Get-AZDOPSProject

## SYNOPSIS

Gets one or several projects in an Azure DevOps organization.

## SYNTAX

```powershell
Get-AZDOPSProject [[-Organization] <String>] [[-Project] <String>] [<CommonParameters>]
```

## DESCRIPTION

Gets one or several projects in an Azure DevOps organization.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-AZDOPSProject -Organization 'azdops' -Project 'azdopsproj'
```

Gets the project called "azdopsproj" from the organization "azdops".

### Example 2

```powershell
PS C:\> Get-AZDOPSProject -Project 'azdopsproj'
```

Gets the project called "azdopsproj" from the default organization.

## PARAMETERS

### -Organization

The name of the organization of the project.

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

The name of the project to find.

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
