---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Get-ADOPSElasticPool

## SYNOPSIS
Gets one or more Azure DevOps Elastic Pools.

## SYNTAX

```
Get-ADOPSElasticPool [[-Organization] <String>] [[-PoolId] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Gets one or more Azure DevOps Elastic Pools.

## EXAMPLES

### Example 1
```powershell
Get-ADOPSElasticPool -Organization ADOPS -PoolId 10
```

Get the Azure DevOps Elastic Pool with the Id of 10 in the ADOPS organization.

### Example 2
```powershell
Get-ADOPSElasticPool -Organization ADOPS
```

Get all the Azure DevOps Elastic Pool in the ADOPS organization.

## PARAMETERS

### -Organization
The identifier of the Azure DevOps organization.

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

### -PoolId
The Id of the Azure DevOps pool.

```yaml
Type: Int32
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
