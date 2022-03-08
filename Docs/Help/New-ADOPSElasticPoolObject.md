---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# New-ADOPSElasticPoolObject

## SYNOPSIS
Creates an Elastic pool object that can be used.

## SYNTAX

```
New-ADOPSElasticPoolObject [-ServiceEndpointId] <Guid> [-ServiceEndpointScope] <Guid> [-AzureId] <String>
 [[-OsType] <String>] [[-MaxCapacity] <Int32>] [[-DesiredIdle] <Int32>] [[-RecycleAfterEachUse] <Boolean>]
 [[-DesiredSize] <Int32>] [[-AgentInteractiveUI] <Boolean>] [[-TimeToLiveMinues] <Int32>]
 [[-MaxSavedNodeCount] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Creates an Elastic pool object that can be used.

## EXAMPLES

### Example 1
```powershell
$AzureDevOpsProject = Get-ADOPSProject -Project 'Azure'
$AzureVMSS = Get-AzVmss -VMScaleSetName 'vmss-test' 
New-ADOPSElasticPoolObject -ServiceEndpointId '44868479-e856-42bf-9a2b-74bb500d8e36' -ServiceEndpointScope $AzureDevOpsProject.Id -AzureId $AzureVMSS.id
```

Gets the Azure DevOps project where the Service endpoint is provisioned.
Gets the Azure Virtual Machine Scale Set named vmss-test.
Creates a new Azure DevOps Elastic Pool object with the correct references to the Azure path to the VMSS and DevOps project scope.

### Example 2
```powershell
New-ADOPSElasticPoolObject -ServiceEndpointId '44868479-e856-42bf-9a2b-74bb500d8e36' -ServiceEndpointScope '421eb3c8-1ca4-4a53-b93c-58997b9eb5e1' -AzureId '/subscriptions/8961f1f1-0bd1-4be0-b73c-6a8f3b304cf6/resourceGroups/ResourceGroupName/providers/Microsoft.Compute/virtualMachineScaleSets/vmss-test'
```

Creates a new Azure DevOps Elastic Pool by using the VMSS 'vmss-test' in the '8961f1f1-0bd1-4be0-b73c-6a8f3b304cf6' subscription.

## PARAMETERS

### -AgentInteractiveUI
Set whether agents should be configured to run with interactive UI

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AzureId
The resource id for the Virtual Machine Scale Set in Azure.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DesiredIdle
Number of agents to have ready waiting for jobs

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DesiredSize
The desired size of the pool

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxCapacity
Maximum number of nodes that will exist in the elastic pool

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxSavedNodeCount
Keep nodes in the pool on failure for investigation

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -OsType
Operating system type of the nodes in the pool

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Linux, Windows

Required: False
Position: 2
Default value: linux
Accept pipeline input: False
Accept wildcard characters: False
```

### -RecycleAfterEachUse
Discard node after each job completes

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServiceEndpointId
Id of the Service Endpoint used to connect to Azure

```yaml
Type: Guid
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServiceEndpointScope
Scope the Service Endpoint belongs to

```yaml
Type: Guid
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TimeToLiveMinues
The minimum time in minutes to keep idle agents alive

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: 15
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputType
In what format should the output be in.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: json, pscustomobject

Required: False
Position: 10
Default value: pscustomobject
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
https://docs.microsoft.com/en-us/rest/api/azure/devops/distributedtask/elasticpools/create?view=azure-devops-rest-7.1