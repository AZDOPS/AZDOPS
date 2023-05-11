---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Get-ADOPSServiceConnection

## SYNOPSIS

Get a specific ServiceConnection or all ServiceConnections in a DevOps project.

## SYNTAX

```
Get-ADOPSServiceConnection [[-Name] <String>] [-Project] <String> [[-Organization] <String>]
 [<CommonParameters>]
```

## DESCRIPTION

Lists a specific ServiceConnection or all ServiceConnections in a Project.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-ADOPSServiceConnection -Organization $OrganizationName -Project $Project -Name $Name
```

Get ServiceConnection with name $Name from $Project.

### Example 2

```powershell
PS C:\> Get-ADOPSServiceConnection -Organization $OrganizationName -Project $Project
```

List all ServiceConnection in $Project

### Example 3

```powershell
PS C:\> Get-ADOPSServiceConnection -Project $Project
```

List all ServiceConnection in $Project and uses Default Organization.

## PARAMETERS

### -Name

Specify the name of a service connection to get.

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

### -Organization

The organization to get ServiceConnection/s from.

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

The project to get ServiceConnection/s from.

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
