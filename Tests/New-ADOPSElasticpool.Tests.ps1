Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot\..\Source\ADOPS -Force

Describe "New-ADOPSElasticpool" {
    Context "Function tests" {
        It "Function exists" {
            { Get-Command -Name New-ADOPSElasticpool -Module ADOPS -ErrorAction Stop } | Should -Not -Throw
        }

        It 'Has parameter <_>' -TestCases 'Organization', 'Body', 'ProjectId', 'PoolName', 'AuthorizeAllPipelines', 'AutoProvisionProjectPools' {
            (Get-Command -Name New-ADOPSElasticpool).Parameters.Keys | Should -Contain $_
        }
    }

    Context "Function returns created elastic pool" {
        BeforeAll {
            Mock InvokeADOPSRestMethod -ModuleName ADOPS {
                [PSCustomObject]@{
                    elasticPool =                                                                                                             
                    @{
                        poolId               = 59
                        serviceEndpointId    = '44868479-e856-42bf-9a2b-74bb500d8e36'
                        serviceEndpointScope = 'a36adc0c-a513-4acd-85bf-2c2a7bb62d30'
                        azureId              = '/subscriptions/6713962a-bebb-45c2-97cd-fb0dead95acf/resourceGroups/resourceGroupName/providers/Microsoft.Compute/virtualMachineScaleSets/vmss-test'
                        maxCapacity          = 1
                        desiredIdle          = 0
                        recycleAfterEachUse  = $True
                        maxSavedNodeCount    = 0
                        osType               = 'linux'
                        state                = 'new'
                        offlineSince         = '2022-03-07 14:38:30'
                        desiredSize          = 0
                        sizingAttempts       = 0
                        agentInteractiveUI   = $False
                        timeToLiveMinutes    = 15
                    }
                }
            }
            Mock -CommandName GetADOPSHeader -ModuleName ADOPS -MockWith {
                @{
                    Header       = @{
                        'Authorization' = 'Basic Base64=='
                    }
                    Organization = 'DummyOrg'
                }
            }

            $body = '{
                "serviceEndpointId": "44868479-e856-42bf-9a2b-74bb500d8e36",
                "serviceEndpointScope": "a36adc0c-a513-4acd-85bf-2c2a7bb62d30",
                "azureId": "/subscriptions/6713962a-bebb-45c2-97cd-fb0dead95acf/resourceGroups/resourceGroupName/providers/Microsoft.Compute/virtualMachineScaleSets/vmss-test",
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
            }'

        }

        It "Returns created elastic pool" {
            New-ADOPSElasticpool -PoolName 'CustomPool' -Body $body -Organization 'DummyOrg' -AuthorizeAllPipelines $true -AutoProvisionProjectPools $true | Should -Not -BeNullOrEmpty
        }

        It "Returns created elastic pool id" {
            (New-ADOPSElasticpool -PoolName 'CustomPool' -Body $body -Organization 'DummyOrg' -AuthorizeAllPipelines $true -AutoProvisionProjectPools $true).elasticPool.poolid | Should -Be 59
        }

    }
}