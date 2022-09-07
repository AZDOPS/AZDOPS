param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe "New-ADOPSElasticpool" {
    Context "Parameters" {
        $TestCases = @(
            @{
                Name = 'Organization'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'ProjectId'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'PoolName'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'AuthorizeAllPipelines'
                Mandatory = $false
                Type = 'switch'
            },
            @{
                Name = 'AutoProvisionProjectPools'
                Mandatory = $false
                Type = 'switch'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command New-ADOPSElasticpool | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }

        # Since this parameter accepts multiple types we create a separate test for it.
        It 'Should have parameter ElasticPoolObject'  {
            Get-Command New-ADOPSElasticpool | Should -HaveParameter 'ElasticPoolObject' -Mandatory
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
            
            Mock GetADOPSHeader -ModuleName ADOPS -MockWith {
                @{
                    Organization = "myorg"
                }
            }
            Mock GetADOPSHeader -ModuleName ADOPS -ParameterFilter { $Organization -eq 'anotherorg' } -MockWith {
                @{
                    Organization = "anotherOrg"
                }
            }

            $ElasticPoolObject = '{
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

        It 'Should get organization from GetADOPSHeader when organization parameter is used' {
            New-ADOPSElasticpool -Organization 'anotherorg' -PoolName 'CustomPool' -ElasticPoolObject $ElasticPoolObject -AuthorizeAllPipelines -AutoProvisionProjectPools
            Should -Invoke GetADOPSHeader -ModuleName ADOPS -ParameterFilter { $Organization -eq 'anotherorg' } -Times 1 -Exactly
        }

        It 'Should validate organization using GetADOPSHeader when organization parameter is not used' {
            New-ADOPSElasticpool -PoolName 'CustomPool' -ElasticPoolObject $ElasticPoolObject -AuthorizeAllPipelines -AutoProvisionProjectPools
            Should -Invoke GetADOPSHeader -ModuleName ADOPS -ParameterFilter { $Organization -eq 'anotherorg' } -Times 0 -Exactly
            Should -Invoke GetADOPSHeader -ModuleName ADOPS -Times 1 -Exactly
        }

        It "Returns created elastic pool" {
            New-ADOPSElasticpool -PoolName 'CustomPool' -ElasticPoolObject $ElasticPoolObject -Organization 'DummyOrg' -AuthorizeAllPipelines -AutoProvisionProjectPools | Should -Not -BeNullOrEmpty
        }

        It "Returns created elastic pool id" {
            (New-ADOPSElasticpool -PoolName 'CustomPool' -ElasticPoolObject $ElasticPoolObject -Organization 'DummyOrg' -AuthorizeAllPipelines -AutoProvisionProjectPools).elasticPool.poolid | Should -Be 59
        }

        It 'Creates correct URI, no projectID' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $URI
            }
            $required = 'https://dev.azure.com/DummyOrg/_apis/distributedtask/elasticpools?poolName=CustomPool&authorizeAllPipelines=true&autoProvisionProjectPools=true&api-version=7.1-preview.1'
            $actual = New-ADOPSElasticpool -PoolName 'CustomPool' -ElasticPoolObject $ElasticPoolObject -Organization 'DummyOrg' -AuthorizeAllPipelines -AutoProvisionProjectPools 
            $actual | Should -Be $required
        }

        It 'Creates correct URI, with projectID' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $URI
            }
            $required = 'https://dev.azure.com/DummyOrg/_apis/distributedtask/elasticpools?poolName=CustomPool&authorizeAllPipelines=true&autoProvisionProjectPools=true&projectId=123&api-version=7.1-preview.1'
            $actual = New-ADOPSElasticpool -PoolName 'CustomPool' -ElasticPoolObject $ElasticPoolObject -Organization 'DummyOrg' -AuthorizeAllPipelines -AutoProvisionProjectPools -ProjectId '123'
            $actual | Should -Be $required
        }

        It 'If it is an object, converts ElasticPoolObject to json' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $body
            }

            $ElasticPoolObject = $ElasticPoolObject | ConvertFrom-Json
            $actual = New-ADOPSElasticpool -PoolName 'CustomPool' -ElasticPoolObject $ElasticPoolObject -Organization 'DummyOrg' -AuthorizeAllPipelines -AutoProvisionProjectPools
            {$actual | ConvertFrom-Json} | Should -Not -Throw
        }

        
        It 'If ElasticPoolObject is an objectthat cant be converted to Json, it should throw' {
            Mock -CommandName ConvertTo-Json -ModuleName ADOPS -MockWith {
                throw
            }

            $ElasticPoolObject = $ElasticPoolObject | ConvertFrom-Json            
            {New-ADOPSElasticpool -PoolName 'CustomPool' -ElasticPoolObject $ElasticPoolObject -Organization 'DummyOrg' -AuthorizeAllPipelines -AutoProvisionProjectPools} | Should -Throw
        }
    }
}