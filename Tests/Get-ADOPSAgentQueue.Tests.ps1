param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'Get-ADOPSAgentQueue' {
    Context 'Parameters' {
        $TestCases = @(
            @{
                Name      = 'Organization'
                Mandatory = $false
                Type      = 'string'
            },
            @{
                Name      = 'Project'
                Mandatory = $true
                Type      = 'string'
            },
            @{
                Name      = 'QueueName'
                Mandatory = $false
                Type      = 'string'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases {
            Get-Command Get-ADOPSAgentQueue | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }

    Context 'Function returns agent pools' {
        BeforeAll {
            Mock InvokeADOPSRestMethod -ModuleName ADOPS {
                [PSCustomObject]@{
                    Value = @(
                        @{
                            id        = 666
                            projectId = '375f9437-4c8f-4dd4-90d6-bc30d38a7264'
                            name      = 'Default'
                            pool      = @{
                                id       = 1
                                scope    = '786f72e5-619f-4fa0-8084-21d73d36d002'
                                name     = 'Default'
                                isHosted = false
                                poolType = 'automation'
                                size     = 0
                                isLegacy = false
                                options  = 'none'
                            }
                        }
                        @{
                            id        = 777
                            projectId = '375f9437-4c8f-4dd4-90d6-bc30d38a7264'
                            name      = 'Hosted'
                            pool      = @{
                                id       = 2
                                scope    = '786f72e5-619f-4fa0-8084-21d73d36d002'
                                name     = 'Hosted'
                                isHosted = true
                                poolType = 'automation'
                                size     = 8
                                isLegacy = true
                                options  = 'none'
                            }
                        }
                    )
                }
            }
            Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'DummyOrg' }
        }

        It 'Should not get organization from GetADOPSDefaultOrganization when organization parameter is used' {
            Get-ADOPSAgentQueue -Project 'DummyProject' -Organization 'anotherorg'
            Should -Invoke GetADOPSDefaultOrganization -ModuleName ADOPS -Times 0 -Exactly
        }

        It 'Should get organization using GetADOPSDefaultOrganization when organization parameter is not used' {
            Get-ADOPSAgentQueue -Project 'DummyProject'
            Should -Invoke GetADOPSDefaultOrganization -ModuleName ADOPS -Times 1 -Exactly
        }
        
        It 'Returns nodes' {
            Get-ADOPSAgentQueue -Project 'DummyProject' | Should -Not -BeNullOrEmpty
        }

        It 'Should invoke InvokeADOPSRestMethod mock' {
            Get-ADOPSAgentQueue -Project 'DummyProject'
            Should -Invoke InvokeADOPSRestMethod -ModuleName ADOPS -Times 1 -Exactly
        }
        
        It 'If no Queuename is given, should return two results' {
            (Get-ADOPSAgentQueue -Project 'DummyProject').Count | Should -Be 2 -Because 'This endpoint returns a Value property that should be expanded.'
        }

        It 'If no Queuename is given, URI Should be correct' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $URI
            }
            $required = 'https://dev.azure.com/DummyOrg/DummyProject/_apis/distributedtask/queues?api-version=7.1'
            $actual = Get-ADOPSAgentQueue -Project 'DummyProject'
            $actual | Should -Be $required
        }
        
        It 'If Queuename is given, URI Should be correct' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $URI
            }
            $required = 'https://dev.azure.com/DummyOrg/DummyProject/_apis/distributedtask/queues?queueName=MyQueue&api-version=7.1'
            $actual = Get-ADOPSAgentQueue -Project 'DummyProject' -QueueName 'MyQueue'
            $actual | Should -Be $required
        }
    }
}