---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Get-ADOPSPool

## SYNOPSIS
Get one or more Azure DevOps Agent pools.

## SYNTAX

### All (Default)
```
Get-ADOPSPool [-Organization <String>] [-IncludeLegacy] [<CommonParameters>]
```

### PoolName
```
Get-ADOPSPool [-Organization <String>] -PoolName <String> [<CommonParameters>]
```

### PoolId
```
Get-ADOPSPool [-Organization <String>] -PoolId <Int32> [<CommonParameters>]
```

## DESCRIPTION
Get one or more Azure DevOps Agent pools.

## EXAMPLES

### Example 1
```powershell
Get-ADOPSPool -Organization 'adops' -IncludeLegacy
```

Get all the Azure DevOps Agent Pools in the Organization of adops and includes Legacy agent pools.

### Example 2
```powershell
Get-ADOPSPool -Organization 'adops' -PoolName 'agentpool1'
```

Get the Azure DevOps Agent Pools with the name of agentpool1 in the Organization of adops.

### Example 3
```powershell
Get-ADOPSPool -Organization 'adops' -PoolId 10
```

Get the Azure DevOps Agent Pools with the pool id of 10 in the Organization of adops.

## PARAMETERS

### -IncludeLegacy
Includes all legacy agent pools.

```yaml
Type: SwitchParameter
Parameter Sets: All
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Organization
The identifier of the Azure DevOps organization.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PoolId
The Agent Pool id.

```yaml
Type: Int32
Parameter Sets: PoolId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PoolName
The name of the Agent pool.

```yaml
Type: String
Parameter Sets: PoolName
Aliases:

Required: True
Position: Named
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
[get-agent-pools](https://docs.microsoft.com/en-us/rest/api/azure/devops/distributedtask/pools/get-agent-pools?view=azure-devops-rest-7.1)
