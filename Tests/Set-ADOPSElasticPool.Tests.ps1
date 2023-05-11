param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe "Set-ADOPSElasticPool" {
    Context "Parameters" {
        $TestCases = @(
            @{
                Name = 'Organization'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'PoolId'
                Mandatory = $true
                Type = 'int'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command Set-ADOPSElasticpool | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
        
        # Since this parameter accepts multiple types we create a separate test for it.
        It 'Should have parameter ElasticPoolObject'  {
            Get-Command Set-ADOPSElasticpool | Should -HaveParameter 'ElasticPoolObject' -Mandatory
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
            
            Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'DummyOrg' }

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

        It 'Should not get organization from GetADOPSDefaultOrganization when organization parameter is used' {
            Set-ADOPSElasticpool -PoolId 59 -ElasticPoolObject $ElasticPoolObject -Organization 'DummyOrg'
            Should -Invoke GetADOPSDefaultOrganization -ModuleName ADOPS -ParameterFilter { $Organization -eq 'DummyOrg' } -Times 0 -Exactly
        }

        It 'Should get organization using GetADOPSDefaultOrganization when organization parameter is not used' {
            Set-ADOPSElasticpool -PoolId 59 -ElasticPoolObject $ElasticPoolObject
            Should -Invoke GetADOPSDefaultOrganization -ModuleName ADOPS -Times 1 -Exactly
        }

        It "Returns updated elastic pool" {
            Set-ADOPSElasticpool -PoolId 59 -ElasticPoolObject $ElasticPoolObject -Organization 'DummyOrg' | Should -Not -BeNullOrEmpty
        }

        It "Returns updated elastic pool id" {
            (Set-ADOPSElasticpool -PoolId 59 -ElasticPoolObject $ElasticPoolObject -Organization 'DummyOrg').elasticPool.maxCapacity | Should -Be 2
        }

        It 'Creates correct URI' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $URI
            }
            $required = 'https://dev.azure.com/DummyOrg/_apis/distributedtask/elasticpools/59?api-version=7.1-preview.1'
            $actual = Set-ADOPSElasticpool -PoolId 59 -ElasticPoolObject $ElasticPoolObject -Organization 'DummyOrg'
            $actual | Should -Be $required
        }

        It 'If it is an object, converts ElasticPoolObject to json' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $body
            }

            $ElasticPoolObject = $ElasticPoolObject | ConvertFrom-Json
            $actual = Set-ADOPSElasticpool -PoolId 59 -ElasticPoolObject $ElasticPoolObject -Organization 'DummyOrg'
            {$actual | ConvertFrom-Json} | Should -Not -Throw
        }

        
        It 'If ElasticPoolObject is an object that cant be converted to Json, it should throw' {
            Mock -CommandName ConvertTo-Json -ModuleName ADOPS -MockWith {
                throw
            }

            $ElasticPoolObject = $ElasticPoolObject | ConvertFrom-Json            
            {Set-ADOPSElasticpool -PoolId 59 -ElasticPoolObject $ElasticPoolObject -Organization 'DummyOrg'} | Should -Throw
        }
    }
}