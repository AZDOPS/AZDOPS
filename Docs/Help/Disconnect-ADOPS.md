---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Disconnect-ADOPS

## SYNOPSIS

Remove an established connection to Azure DevOps.

## SYNTAX

```powershell
Disconnect-ADOPS [[-Organization] <String>] [<CommonParameters>]
```

## DESCRIPTION

Remove an established connection to Azure DevOps.

## EXAMPLES

### Example 1

```powershell
PS C:\> Disconnect-ADOPS -Organization 'ADOPS'
```

Removes the established connection to the organization "ADOPS".

### Example 2

```powershell
PS C:\> Disconnect-ADOPS
```

Removes the established connection without specifying organization, if there is only one.

## PARAMETERS

### -Organization

The organization to remove the connection for.

This parameter is required if multiple connections are made.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
