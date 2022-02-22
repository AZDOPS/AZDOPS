_Manually created by Sebastian Claesson_

Example:
```powershell
New-AZDOPSElasticPool -PoolName ManagedPool1 -Body <String>
```

Example - Auto provisions in project and Authorizes the pool to be consumed by all pipelines.
```powershell
New-AZDOPSElasticPool -PoolName ManagedPool1 -Body @"{
  "poolId": 10,
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
"@ -AuthorizeAllPipelines $true -AutoProvisionProjectPools $true
```