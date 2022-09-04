BeforeDiscovery {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSScriptRoot\..\Source\ADOPS -Force
}

Describe "Get-ADOPSElasticPool" {
    Context "Parameters" {
        $TestCases = @(
            @{
                Name = 'Organization'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'PoolId'
                Mandatory = $false
                Type = 'int32'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command Get-ADOPSElasticPool | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }

    Context "Function returns elastic pools" {
        BeforeAll {
            Mock InvokeADOPSRestMethod -ModuleName ADOPS {
                [PSCustomObject]@{
                    Value = @(
                        @{
                            poolId               = 10
                            serviceEndpointId    = '577305a1-e95f-40e3-a3fe-447662e56f2c'
                            serviceEndpointScope = 'd05210c4-6cd1-4cb6-98a3-0de903418de8'
                            azureId              = '/subscriptions/f47626a9-67f2-4a30-a0d9-22806c3b99bd/resourceGroups/ResourceGroupName/providers/Microsoft.Compute/virtualMachineScaleSets/VirtualMachineScaleSetName'
                            maxCapacity          = 1
                            desiredIdle          = 0
                            recycleAfterEachUse  = $True
                            maxSavedNodeCount    = 0
                            osType               = 'linux'
                            state                = 'online'
                            offlineSince         = ''
                            desiredSize          = 0
                            sizingAttempts       = 0
                            agentInteractiveUI   = $False
                            timeToLiveMinutes    = 15
                        },
                        @{
                            poolId               = 11
                            serviceEndpointId    = 'f71a8108-79a3-4efb-889d-caf028432dff'
                            serviceEndpointScope = 'c7aae1c8-fef0-4544-8ea3-1f14f3942b2c'
                            azureId              = '/subscriptions/2b694a53-1153-43a3-ae8c-7732c72e780b/resourceGroups/ResourceGroupNameTwo/providers/Microsoft.Compute/virtualMachineScaleSets/VirtualMachineScaleSetNameTwo'
                            maxCapacity          = 1
                            desiredIdle          = 0
                            recycleAfterEachUse  = $True
                            maxSavedNodeCount    = 0
                            osType               = 'linux'
                            state                = 'online'
                            offlineSince         = ''
                            desiredSize          = 0
                            sizingAttempts       = 0
                            agentInteractiveUI   = $False
                            timeToLiveMinutes    = 15
                        }
                    )
                }
            }
            Mock -CommandName GetADOPSHeader -ModuleName ADOPS -MockWith {
                @{
                    Header       = @{
                        'Authorization' = 'Basic Base64=='
                    }
                    Organization = 'MySecondOrg'
                }
            } -ParameterFilter { $Organization -eq 'MySecondOrg' }
            Mock -CommandName GetADOPSHeader -ModuleName ADOPS -MockWith {
                @{
                    Header       = @{
                        'Authorization' = 'Basic Base64=='
                    }
                    Organization = 'DummyOrg'
                }
            }
        }

        It "Returns elastic pool" {
            Get-ADOPSElasticPool -Organization 'DummyOrg' -poolId 10 | Should -Not -BeNullOrEmpty
        }

        It "Returns elastic pool without poolid specified" {
            Get-ADOPSElasticPool -Organization 'DummyOrg' | Should -Not -BeNullOrEmpty
        }

        It 'Returns an id' {
            (Get-ADOPSElasticPool -Organization 'DummyOrg').poolId | Should -Contain 11
        }

        It 'Returns an azure id' {
            (Get-ADOPSElasticPool -Organization 'DummyOrg' -PoolId 10).azureId | Should -Contain '/subscriptions/f47626a9-67f2-4a30-a0d9-22806c3b99bd/resourceGroups/ResourceGroupName/providers/Microsoft.Compute/virtualMachineScaleSets/VirtualMachineScaleSetName'
        }

        It 'Calls InvokeADOPSRestMethod with correct parameters when Organization is used' {
            Get-ADOPSElasticPool -Organization 'MySecondOrg'
            Should -Invoke InvokeADOPSRestMethod -ModuleName ADOPS -Times 1 -Exactly -ParameterFilter { $Uri -eq 'https://dev.azure.com/MySecondOrg/_apis/distributedtask/elasticpools?api-version=7.1-preview.1' }
        }

        It 'Calls InvokeADOPSRestMethod when no parameters is used' {
            Get-ADOPSElasticPool
            Should -Invoke InvokeADOPSRestMethod -ModuleName ADOPS -Times 1 -Exactly -ParameterFilter { $Uri -eq 'https://dev.azure.com/DummyOrg/_apis/distributedtask/elasticpools?api-version=7.1-preview.1' }
        }

        It 'Can handle single elastic pool responses from API' {
            Mock InvokeADOPSRestMethod -ModuleName ADOPS {
                [PSCustomObject]@{
                    poolId               = 10
                    serviceEndpointId    = '577305a1-e95f-40e3-a3fe-447662e56f2c'
                    serviceEndpointScope = 'd05210c4-6cd1-4cb6-98a3-0de903418de8'
                    azureId              = '/subscriptions/f47626a9-67f2-4a30-a0d9-22806c3b99bd/resourceGroups/ResourceGroupName/providers/Microsoft.Compute/virtualMachineScaleSets/VirtualMachineScaleSetName'
                    maxCapacity          = 1
                    desiredIdle          = 0
                    recycleAfterEachUse  = $True
                    maxSavedNodeCount    = 0
                    osType               = 'linux'
                    state                = 'online'
                    offlineSince         = ''
                    desiredSize          = 0
                    sizingAttempts       = 0
                    agentInteractiveUI   = $False
                    timeToLiveMinutes    = 15
                }
            }
            
            (Get-ADOPSElasticPool -Organization 'DummyOrg' -PoolId 10).poolId | Should -Be 10
        }
    }
}