Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot\..\Source\ADOPS -Force

Describe "New-ADOPSElasticpool" {
    Context "Function tests" {
        BeforeAll {
            InModuleScope -ModuleName ADOPS {
                Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                    return $InvokeSplat
                }

                Mock -CommandName GetADOPSHeader -ModuleName ADOPS -MockWith {
                    @{
                        Header       = @{
                            'Authorization' = 'Basic Base64=='
                        }
                        Organization = $OrganizationName
                    }
                }
            }

        }

        It "Function exists" {
            { Get-Command -Name New-ADOPSElasticpool -Module ADOPS -ErrorAction Stop } | Should -Not -Throw
        }

        It 'Has parameter <_>' -TestCases 'Organization', 'ElasticPoolObject', 'ProjectId', 'PoolName', 'AuthorizeAllPipelines', 'AutoProvisionProjectPools' {
            (Get-Command -Name New-ADOPSElasticpool).Parameters.Keys | Should -Contain $_
        }
        It 'PoolName should be required' {
            (Get-Command New-ADOPSElasticpool).Parameters['PoolName'].Attributes.Mandatory | Should -Be $true
        }
        It 'ElasticPoolObject should be required' {
            (Get-Command New-ADOPSElasticpool).Parameters['ElasticPoolObject'].Attributes.Mandatory | Should -Be $true
        }

        It 'Should have called mock' {
            $r = New-ADOPSElasticPool -PoolName 'DummyPoolName' -ElasticPoolObject 'EPO' -Organization 'DummyOrg' -ProjectId 'ProjectId' -AuthorizeAllPipelines $true -AutoProvisionProjectPools $true
            Should -Invoke 'InvokeADOPSRestMethod' -ModuleName 'ADOPS' -Exactly -Times 1
            Should -Invoke 'GetADOPSHeader' -ModuleName 'ADOPS' -Exactly -Times 1
        }

        It 'Verifying invoke object, URI' {
            $r = New-ADOPSElasticPool -PoolName 'DummyPoolName' -ElasticPoolObject 'EPO' -Organization 'DummyOrg' -ProjectId 'ProjectId' -AuthorizeAllPipelines $true -AutoProvisionProjectPools $true
            $r.uri | Should -Be "https://dev.azure.com/DummyOrg/_apis/distributedtask/elasticpools?poolName=DummyPoolName&authorizeAllPipelines=true&autoProvisionProjectPools=true&projectId=ProjectId&api-version=7.1-preview.1"
        }
        It 'Verifying invoke object, method' {
            $r = New-ADOPSElasticPool -PoolName 'DummyPoolName' -ElasticPoolObject 'EPO' -Organization 'DummyOrg' -ProjectId 'ProjectId' -AuthorizeAllPipelines $true -AutoProvisionProjectPools $true
            $r.method | Should -Be 'Post'
        }
        It 'Verifying invoke object, Organization' {
            $r = New-ADOPSElasticPool -PoolName 'DummyPoolName' -ElasticPoolObject 'EPO' -Organization 'DummyOrg' -ProjectId 'ProjectId' -AuthorizeAllPipelines $true -AutoProvisionProjectPools $true
            $r.Organization | Should -Be 'DummyOrg'
        }
        It 'Verifying invoke object, Body' {
            $r = New-ADOPSElasticPool -PoolName 'DummyPoolName' -ElasticPoolObject '{"EpoKey":"EPO"}' -Organization 'DummyOrg' -ProjectId 'ProjectId' -AuthorizeAllPipelines $true -AutoProvisionProjectPools $true
            $r.Body | Should -Be '{"EpoKey":"EPO"}'
        }

        It 'If elasticPoolObject is not a Json, try to convert it' {
            $r = New-ADOPSElasticPool -PoolName 'DummyPoolName' -ElasticPoolObject (@{'EpoKey'='EPO'}) -Organization 'DummyOrg' -ProjectId 'ProjectId' -AuthorizeAllPipelines $true -AutoProvisionProjectPools $true
            $r.Body | Should -Be '{"EpoKey":"EPO"}'
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

        It "Returns created elastic pool" {
            New-ADOPSElasticpool -PoolName 'CustomPool' -ElasticPoolObject $ElasticPoolObject -Organization 'DummyOrg' -AuthorizeAllPipelines $true -AutoProvisionProjectPools $true | Should -Not -BeNullOrEmpty
        }

        It "Returns created elastic pool id" {
            (New-ADOPSElasticpool -PoolName 'CustomPool' -ElasticPoolObject $ElasticPoolObject -Organization 'DummyOrg' -AuthorizeAllPipelines $true -AutoProvisionProjectPools $true).elasticPool.poolid | Should -Be 59
        }

    }
}