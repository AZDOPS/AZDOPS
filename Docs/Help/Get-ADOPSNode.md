---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Get-ADOPSNode

## SYNOPSIS
Get one or more Elastic nodes currently in the Elastic pool.

## SYNTAX

```
Get-ADOPSNode [-PoolId] <Int32> [[-Organization] <String>] [<CommonParameters>]
```

## DESCRIPTION
Get one or more Elastic nodes currently in the Elastic pool.

## EXAMPLES

### Example 1
```powershell
Get-ADOPSNode -Organization 'ADOPS' -PoolId 10
```

Get the elastic nodes in the elastic pool with id 10.

## PARAMETERS

### -Organization
The identifier of the Azure DevOps organization.

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

### -PoolId
The unique Id of the Elastic pool.

```yaml
Type: Int32
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
