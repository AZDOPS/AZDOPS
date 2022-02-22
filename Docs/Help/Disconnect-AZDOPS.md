---
external help file: AZDOPS-help.xml
Module Name: AZDOPS
online version:
schema: 2.0.0
---

# Disconnect-AZDOPS

## SYNOPSIS

Remove an established connection to Azure DevOps.

## SYNTAX

```powershell
Disconnect-AZDOPS [[-Organization] <String>] [<CommonParameters>]
```

## DESCRIPTION

Remove an established connection to Azure DevOps.

## EXAMPLES

### Example 1

```powershell
PS C:\> Disconnect-AZDOPS -Organization 'azdops'
```

Removes the established connection to the organization "azdops".

### Example 2

```powershell
PS C:\> Disconnect-AZDOPS
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
