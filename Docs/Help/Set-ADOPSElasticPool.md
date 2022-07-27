---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Set-ADOPSElasticPool

## SYNOPSIS
Updates an Azure DevOps Elastic pool.

## SYNTAX

```
Set-ADOPSElasticPool [-PoolId] <Int32> [-ElasticPoolObject] <Object> [[-Organization] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Updates an Azure DevOps Elastic pool.

## EXAMPLES

### Example 1
```powershell
PS C:\> $AzureDevOpsProject = Get-ADOPSProject -Project 'ADOPS'
$AzureVMSS = Get-AzVmss -VMScaleSetName 'adops-vmss'
$PoolInformation = Get-ADOPSPool -PoolName 'adopsPool'
$ElasticPoolObject = New-ADOPSElasticPoolObject -ServiceEndpointId 'd6040a29-d507-43b0-a72d-99a50cb3a9d3' -ServiceEndpointScope $AzureDevOpsProject.Id -AzureId $AzureVMSS.id -DesiredIdle 2 -MaxCapacity 2
Set-ADOPSElasticPool -PoolId $PoolInformation.id -ElasticPoolObject $ElasticPoolObject
```

Retrieves the Azure DevOps Project specified, the Azure Virtual Machine Scale-set.
Generates a Elastic pool object using the New-ADOPSElasticPoolObject function and then updates the Elastic Pool id Azure using it's unique id.

## PARAMETERS

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
Type: Object
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

### -PoolId
The unique Azure DevOps Pool id.

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
