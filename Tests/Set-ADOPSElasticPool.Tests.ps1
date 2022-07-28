BeforeDiscovery {
    . $PSScriptRoot\TestHelpers.ps1
    Initialize-TestSetup
}

Describe "Set-ADOPSElasticPool" {
    Context 'Parameter validation' {
        It 'Has parameter <_.Name>' -TestCases @(
            @{ Name = 'PoolId'; Mandatory = $true }
            @{ Name = 'ElasticPoolObject'; Mandatory = $true }
            @{ Name = 'Organization'; }
        ) {
            Get-Command -Name Set-ADOPSElasticPool | Should -HaveParameterStrict $Name -Mandatory:([bool]$Mandatory) -Type $Type
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
                        maxCapacity          = 2
                        desiredIdle          = 2
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

            $ElasticPoolObject = '{
                "serviceEndpointId": "44868479-e856-42bf-9a2b-74bb500d8e36",
                "serviceEndpointScope": "a36adc0c-a513-4acd-85bf-2c2a7bb62d30",
                "azureId": "/subscriptions/6713962a-bebb-45c2-97cd-fb0dead95acf/resourceGroups/resourceGroupName/providers/Microsoft.Compute/virtualMachineScaleSets/vmss-test",
                "maxCapacity": 2,
                "desiredIdle": 2,
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

        It "Returns updated elastic pool" {
            Set-ADOPSElasticpool -PoolId 59 -ElasticPoolObject $ElasticPoolObject -Organization 'DummyOrg' | Should -Not -BeNullOrEmpty
        }

        It "Returns updated elastic pool id" {
            (Set-ADOPSElasticpool -PoolId 59 -ElasticPoolObject $ElasticPoolObject -Organization 'DummyOrg').elasticPool.maxCapacity | Should -Be 2
        }

    }
}