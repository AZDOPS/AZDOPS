---
external help file:
Module Name:
online version:
schema: 2.0.0
---

# Get-ADOPSOrganizationCommerceMeterUsage

## SYNOPSIS
Get the Azure DevOps Organization Storage Usage

## SYNTAX

```
Get-ADOPSOrganizationCommerceMeterUsage [[-Organization] <String>] [[-MeterId] <String>] [<CommonParameters>]
```

## DESCRIPTION
Get the Azure DevOps Organization Storage Usage

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-ADOPSOrganizationCommerceMeterUsage
```

Get the Azure DevOps Organization Storage Usage using default MeterId

### Example 2
```powershell
PS C:\> Get-ADOPSOrganizationCommerceMeterUsage -MeterId '3efc2e47-d73e-4213-8368-3a8723ceb1cc'
```

Get the Azure DevOps Organization Storage Usage for MeterId '3efc2e47-d73e-4213-8368-3a8723ceb1cc' (Artifacts)

## PARAMETERS

### -MeterId
The MeterId for commerce meter usage.

Other valid MeterIds are;

meterId                              meterKind
-------                              ---------
3efc2e47-d73e-4213-8368-3a8723ceb1cc artifacts
4bad9897-8d87-43bb-80be-5e6e8fefa3de commitment
f44a67f2-53ae-4044-bd58-1c8aca386b98 commitment
3fa30bbe-3437-42d4-a978-0ef84811f470 commitment
2fa36572-3c3d-46be-ac59-6053cbb377b4 commitment
e2c73ec7-cb60-4142-b8b2-e216b6c09c1a resource
a7d460a9-a56d-4b64-837f-14728d6d54d4 resource
256caf12-9779-4531-99ac-b46e295130a3 resource


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

### -Organization
The organization to get the storage usage from.

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
