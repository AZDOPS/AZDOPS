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

```
Disconnect-ADOPS [<CommonParameters>]
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
