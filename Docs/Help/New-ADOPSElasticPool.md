---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# New-ADOPSElasticPool

## SYNOPSIS
Create an Azure DevOps Elastic pool.

## SYNTAX

```
New-ADOPSElasticPool [-PoolName] <String> [-ElasticPoolObject] [[-Organization] <String>] [[-ProjectId] <Guid>]
 [[-AuthorizeAllPipelines] <Boolean>] [[-AutoProvisionProjectPools] <Boolean>] [<CommonParameters>]
```

## DESCRIPTION
Create an Azure DevOps Elastic pool.

## EXAMPLES

### Example 1
```powershell
$Params = @{
    AuthorizeAllPipelines = $true
    AutoProvisionProjectPools = $true
    PoolName = ManagedPool1
}
New-ADOPSElasticPool @Params -ElasticPoolObject @"
{
  "serviceEndpointId": "44868479-e856-42bf-9a2b-74bb500d8e36",
  "serviceEndpointScope": "421eb3c8-1ca4-4a53-b93c-58997b9eb5e1",
  "azureId": "/subscriptions/d83a7278-278c-4671-9a3e-a4cd81cd1194/resourceGroups/RG-TEST/providers/Microsoft.Compute/virtualMachineScaleSets/vmss-test",
  "maxCapacity": 1,
  "desiredIdle": 0,
  "recycleAfterEachUse": true,
  "maxSavedNodeCount": 0,
  "osType": "linux",
  "state": "online",
  "offlineSince": null,
  "desiredSize": 0,
  "sizingAttempts": 0,
  "agentInteractiveUI": false,
  "timeToLiveMinutes": 15
}
"@
```
To find your serviceEndpointScope, use Get-ADOPSProject as the scope is the project where the Service connection is bound.
Create a Azure DevOps Elastic pool that Auto provisions in project and Authorizes the pool to be consumed by all pipelines.
It also attaches to a Virtual Machine Scale Set using the azureId.
Full description of the request body can be found at: https://docs.microsoft.com/en-us/rest/api/azure/devops/distributedtask/elasticpools/create?view=azure-devops-rest-7.1


### Example 2
```powershell
$Params = @{
    AuthorizeAllPipelines = $true
    AutoProvisionProjectPools = $true
    PoolName = ManagedPool1
}

$ElasticPoolObject = New-ADOPSElasticPoolObject -ServiceEndpointId '44868479-e856-42bf-9a2b-74bb500d8e36' -ServiceEndpointScope '421eb3c8-1ca4-4a53-b93c-58997b9eb5e1' -AzureId '/subscriptions/8961f1f1-0bd1-4be0-b73c-6a8f3b304cf6/resourceGroups/ResourceGroupName/providers/Microsoft.Compute/virtualMachineScaleSets/vmss-test'

New-ADOPSElasticPool @Params -ElasticPoolObject $ElasticPoolObject
```
To find your serviceEndpointScope, use Get-ADOPSProject as the scope is the project where the Service connection is bound.
Create a Azure DevOps Elastic pool that Auto provisions in project and Authorizes the pool to be consumed by all pipelines.
It also attaches to a Virtual Machine Scale Set using the azureId.
Full description of the request body can be found at: https://docs.microsoft.com/en-us/rest/api/azure/devops/distributedtask/elasticpools/create?view=azure-devops-rest-7.1
## PARAMETERS

### -AuthorizeAllPipelines
Setting to determine if all pipelines are authorized to use this TaskAgentPool by default.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AutoProvisionProjectPools
Setting to automatically provision TaskAgentQueues in every project for the new pool.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ElasticPoolObject
The full request body in json or as a pscustom object. 
The Help function New-ElasticPoolObject can help generate a powershell object/json string.

| Name                 | Type                | Description                                                                   |
|----------------------|---------------------|-------------------------------------------------------------------------------|
| agentInteractiveUI   | boolean             | Set whether agents should be configured to run with interactive UI            |
| azureId              | string              | Azure string representing to location of the resource                         |
| desiredIdle          | integer             | Number of agents to have ready waiting for jobs                               |
| desiredSize          | integer             | The desired size of the pool                                                  |
| maxCapacity          | integer             | Maximum number of nodes that will exist in the elastic pool                   |
| maxSavedNodeCount    | integer             | Keep nodes in the pool on failure for investigation                           |
| offlineSince         | string              | Timestamp the pool was first detected to be offline                           |
| osType               | OperatingSystemType | Operating system type of the nodes in the pool                                |
| poolId               | integer             | Id of the associated TaskAgentPool                                            |
| recycleAfterEachUse  | boolean             | Discard node after each job completes                                         |
| serviceEndpointId    | string              | Id of the Service Endpoint used to connect to Azure                           |
| serviceEndpointScope | string              | Scope the Service Endpoint belongs to                                         |
| sizingAttempts       | integer             | The number of sizing attempts executed while trying to achieve a desired size |
| state                | ElasticPoolState    | State of the pool                                                             |
| timeToLiveMinutes    | integer             | The minimum time in minutes to keep idle agents alive                         |

```yaml
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Organization
Name of Azure DevOps organization.

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

### -PoolName
Name of the Elastic Pool.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProjectId
If provided, a new TaskAgentQueue will be created in the specified project.

```yaml
Type: Guid
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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
[elasticpools-create](https://docs.microsoft.com/en-us/rest/api/azure/devops/distributedtask/elasticpools/create?view=azure-devops-rest-7.1)
