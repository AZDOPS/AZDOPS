BeforeDiscovery {
    . $PSScriptRoot\TestHelpers.ps1
    Initialize-TestSetup
}

Describe "Get-ADOPSNode" {
    It 'Has parameter <_.Name>' -TestCases @(
        @{ Name = 'PoolId'; }
        @{ Name = 'Organization'; }
    ) {
        Get-Command -Name Get-ADOPSNode| Should -HaveParameter $Name -Mandatory:([bool]$Mandatory) -Type $Type
    }

    Context "Function returns repositories" {
        BeforeAll {
            Mock InvokeADOPSRestMethod -ModuleName ADOPS {
                [PSCustomObject]@{
                    Value = @(
                        @{
                            poolId         = 10
                            id             = 3
                            name           = 'vmss-test000000'
                            state          = 'idle'
                            stateChangedOn = '2022-03-07 13:42:06'
                            desiredState   = 'none'
                            agentId        = 10
                            agentState     = @('enabled', 'online')
                            computeId      = 0
                            computeState   = 'healthy'
                            requestId      = ''
                        },
                        @{
                            poolId         = 10
                            id             = 4
                            name           = 'vmss-test000001'
                            state          = 'idle'
                            stateChangedOn = '2022-03-07 13:52:08'
                            desiredState   = 'none'
                            agentId        = 12
                            agentState     = @('enabled', 'online')
                            computeId      = 1
                            computeState   = 'healthy'
                            requestId      = ''
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

        It "Returns nodes" {
            Get-ADOPSNode -Organization 'DummyOrg' -poolId 10 | Should -Not -BeNullOrEmpty
        }

        It 'Returns an id' {
            (Get-ADOPSNode -Organization 'DummyOrg' -PoolId 10).id | Should -Contain 3
        }

        It 'Returns a node name' {
            (Get-ADOPSNode -Organization 'DummyOrg' -PoolId 10).name | Should -Contain 'vmss-test000001'
        }

        It 'Calls InvokeADOPSRestMethod with correct parameters when Organization is used' {
            Get-ADOPSNode -Organization 'MySecondOrg' -PoolId 10
            Should -Invoke InvokeADOPSRestMethod -ModuleName ADOPS -Times 1 -Exactly -ParameterFilter { $Uri -eq 'https://dev.azure.com/MySecondOrg/_apis/distributedtask/elasticpools/10/nodes?api-version=7.1-preview.1' }
        }

        It 'Calls InvokeADOPSRestMethod when only PoolId is used' {
            Get-ADOPSNode -PoolId 10
            Should -Invoke InvokeADOPSRestMethod -ModuleName ADOPS -Times 1 -Exactly -ParameterFilter { $Uri -eq 'https://dev.azure.com/DummyOrg/_apis/distributedtask/elasticpools/10/nodes?api-version=7.1-preview.1' }
        }

        It 'Can handle single node responses from API' {
            Mock InvokeADOPSRestMethod -ModuleName ADOPS {
                [PSCustomObject]@{
                    poolId         = 10
                    id             = 3
                    name           = 'vmss-test000000'
                    state          = 'idle'
                    stateChangedOn = '2022-03-07 13:42:06'
                    desiredState   = 'none'
                    agentId        = 10
                    agentState     = @('enabled', 'online')
                    computeId      = 0
                    computeState   = 'healthy'
                    requestId      = ''
                }
            }

            (Get-ADOPSNode -Organization 'DummyOrg' -PoolId 10).name | Should -Be 'vmss-test000000'
        }
    }
}