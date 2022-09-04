BeforeDiscovery {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSScriptRoot\..\Source\ADOPS -Force
}

Describe "Get-ADOPSPool" {
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
                Type = 'int32'
            },
            @{
                Name = 'PoolName'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'IncludeLegacy'
                Mandatory = $false
                Type = 'switch'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command Get-ADOPSPool | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }

    Context "Function returns agent pools" {
        BeforeAll {
            Mock InvokeADOPSRestMethod -ModuleName ADOPS {
                [PSCustomObject]@{
                    Value = @(
                        @{
                            createdOn     = '2022-01-25 16:34:10'
                            autoProvision = $True
                            autoUpdate    = $True
                            autoSize      = $True
                            targetSize    = 1
                            agentCloudId  = 1
                            id            = 8
                            scope         = '3ca1f786-8df2-4ce5-bd2a-bf240c9a9594'
                            name          = 'Hosted Ubuntu 1604'
                            isHosted      = $True
                            poolType      = 'automation'
                            size          = 1
                            isLegacy      = $True
                            options       = 'none'
                        }
                        @{
                            createdOn     = '2022-01-25 16:34:10'
                            autoProvision = $True
                            autoUpdate    = $True
                            autoSize      = $True
                            targetSize    = 1
                            agentCloudId  = 1
                            id            = 9
                            scope         = '3ca1f786-8df2-4ce5-bd2a-bf240c9a9594'
                            name          = 'Azure Pipelines'
                            isHosted      = $True
                            poolType      = 'automation'
                            size          = 1
                            isLegacy      = $False
                            options       = 'none'
                        }
                        @{
                            createdOn     = '2022-01-28 13:22:33'
                            autoProvision = $False
                            autoUpdate    = $True
                            autoSize      = $True
                            targetSize    = ''
                            agentCloudId  = ''
                            id            = 10
                            scope         = '3ca1f786-8df2-4ce5-bd2a-bf240c9a9594'
                            name          = 'custom agent pool'
                            isHosted      = $False
                            poolType      = 'automation'
                            size          = 3
                            isLegacy      = $False
                            options       = @('elasticPool', 'singleUseAgents')
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
            Get-ADOPSPool -Organization 'DummyOrg' -poolId 10 | Should -Not -BeNullOrEmpty
        }

        It 'Returns an name' {
            (Get-ADOPSPool -Organization 'DummyOrg' -PoolId 10).name | Should -Contain 'custom agent pool'
        }

        It 'Returns all pools when Legacy is included' {
            (Get-ADOPSPool -Organization 'DummyOrg' -IncludeLegacy).Count | Should -Be 3
        }

        It 'Returns only non legacy pools when Legacy is not set and no parameters given' {
            (Get-ADOPSPool).Count | Should -Be 2
        }

        It 'Calls InvokeADOPSRestMethod with correct parameters when Organization is used' {
            Get-ADOPSPool -Organization 'MySecondOrg' -PoolId 10
            Should -Invoke InvokeADOPSRestMethod -ModuleName ADOPS -Times 1 -Exactly -ParameterFilter { $Uri -eq 'https://dev.azure.com/MySecondOrg/_apis/distributedtask/pools/10?api-version=7.1-preview.1' }
        }

        It 'Calls InvokeADOPSRestMethod when only PoolId is used' {
            Get-ADOPSPool -PoolId 10
            Should -Invoke InvokeADOPSRestMethod -ModuleName ADOPS -Times 1 -Exactly -ParameterFilter { $Uri -eq 'https://dev.azure.com/DummyOrg/_apis/distributedtask/pools/10?api-version=7.1-preview.1' }
        }

        It 'Calls InvokeADOPSRestMethod when only PoolName is used' {
            Get-ADOPSPool -PoolName 'custom agent pool'
            Should -Invoke InvokeADOPSRestMethod -ModuleName ADOPS -Times 1 -Exactly -ParameterFilter { $Uri -eq 'https://dev.azure.com/DummyOrg/_apis/distributedtask/pools?poolName=custom agent pool&api-version=7.1-preview.1' }
        }

        It 'Can handle single node responses from API' {
            Mock InvokeADOPSRestMethod -ModuleName ADOPS {
                [PSCustomObject]@{
                    createdOn     = '2022-01-25 16:34:10'
                    autoProvision = $True
                    autoUpdate    = $True
                    autoSize      = $True
                    targetSize    = 1
                    agentCloudId  = 1
                    id            = 8
                    scope         = '3ca1f786-8df2-4ce5-bd2a-bf240c9a9594'
                    name          = 'Hosted Ubuntu 1604'
                    isHosted      = $True
                    poolType      = 'automation'
                    size          = 1
                    isLegacy      = $True
                    options       = 'none'
                }
            }
            
            (Get-ADOPSPool -Organization 'DummyOrg' -PoolId 8).name | Should -Be 'Hosted Ubuntu 1604'
        }
    }
}