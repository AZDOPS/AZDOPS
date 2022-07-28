BeforeDiscovery {
    . $PSScriptRoot\TestHelpers.ps1
    Initialize-TestSetup
}

Describe 'Start-ADOPSPipeline' {
    It 'Has parameter <_.Name>' -TestCases @(
        @{ Name = 'Name'; Mandatory = $true }
        @{ Name = 'Project'; Mandatory = $true }
        @{ Name = 'Branch'; }
        @{ Name = 'Organization'; }
    ) {
        Get-Command -Name Start-ADOPSPipeline | Should -HaveParameter $Name -Mandatory:([bool]$Mandatory) -Type $Type
    }

    Context 'Starting pipeline' {
        BeforeAll {
            InModuleScope -ModuleName ADOPS {
                Mock -CommandName GetADOPSHeader -ModuleName ADOPS -MockWith {
                    @{
                        Header       = @{
                            'Authorization' = 'Basic Base64=='
                        }
                        Organization = 'DummyOrg'
                    }
                } -ParameterFilter { $Organization -eq 'Organization' }
                Mock -CommandName GetADOPSHeader -ModuleName ADOPS -MockWith {
                    @{
                        Header       = @{
                            'Authorization' = 'Basic Base64=='
                        }
                        Organization = 'DummyOrg'
                    }
                }

                Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                    '{"count":2,"value":[{"_links":{"self":{"href":"https://dev.azure.com/dummyorg/9ca5975f-7615-4f60-927d-d9222b095544/_apis/pipelines/1?revision=1"},"web":{"href":"https://dev.azure.com/dummyorg/9ca5975f-7615-4f60-927d-d9222b095544/_build/definition?definitionId=1"}},"url":"https://dev.azure.com/dummyorg/9ca5975f-7615-4f60-927d-d9222b095544/_apis/pipelines/1?revision=1","id":1,"revision":1,"name":"dummypipeline1","folder":"\\"},{"_links":{"self":{"href":"https://dev.azure.com/dummyorg/9ca5975f-7615-4f60-927d-d9222b095544/_apis/pipelines/3?revision=1"},"web":{"href":"https://dev.azure.com/dummyorg/9ca5975f-7615-4f60-927d-d9222b095544/_build/definition?definitionId=3"}},"url":"https://dev.azure.com/dummyorg/9ca5975f-7615-4f60-927d-d9222b095544/_apis/pipelines/3?revision=1","id":3,"revision":1,"name":"ummypipeline2","folder":"\\"}]}' | ConvertFrom-Json
                } -ParameterFilter { $method -eq 'Get' }

                Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                    return $InvokeSplat
                } -ParameterFilter { $method -eq 'post' }
            }
        }

        It 'Should call mock InvokeADOPSRestMethod' {
            Start-ADOPSPipeline -Name 'DummyPipeline1' -Project 'DummyProject'
            Should -Invoke 'InvokeADOPSRestMethod' -ModuleName 'ADOPS' -Exactly -Times 2
        }
        It 'If no organization is passed, Get default' {
            Start-ADOPSPipeline -Name 'DummyPipeline1' -Project 'DummyProject'
            Should -Invoke 'GetADOPSHeader' -ModuleName 'ADOPS' -Exactly -Times 1
        }

        It 'If an organization is passed, that organization should be used for URI' {
            Start-ADOPSPipeline -Name 'DummyPipeline1' -Project 'DummyProject' -Organization 'Organization'
            Should -Invoke 'GetADOPSHeader' -ModuleName 'ADOPS' -Exactly -Times 1 -ParameterFilter { $Organization -eq 'Organization' }
        }
        It 'If no pipeline with correct name is found we should throw error' {
            { Start-ADOPSPipeline -Name 'NonExistingPipeline' -Project 'DummyProject' -Organization 'Organization' } | Should -Throw
        }

        It 'Uri should be set correct' {
            $r = Start-ADOPSPipeline -Name 'DummyPipeline1' -Project 'DummyProject'
            $r.Uri | Should -Be 'https://dev.azure.com/DummyOrg/DummyProject/_apis/pipelines/1/runs?api-version=7.1-preview.1'
        }
        It 'Method should be post' {
            $r = Start-ADOPSPipeline -Name 'DummyPipeline1' -Project 'DummyProject'
            $r.Method | Should -Be 'post'
        }
        It 'Body should be set with branch name. If no branch is given, "main"' {
            $r = Start-ADOPSPipeline -Name 'DummyPipeline1' -Project 'DummyProject'
            $r.Body | Should -BeLike '*main*'
        }
        It 'Body should be set with branch name If branch is given as parameter, "branch"' {
            $r = Start-ADOPSPipeline -Name 'DummyPipeline1' -Project 'DummyProject' -Branch 'branch'
            $r.Body | Should -BeLike '*branch*'
        }
        It 'Organization should be of type string' {
            $r = Start-ADOPSPipeline -Name 'DummyPipeline1' -Project 'DummyProject' -Branch 'branch'
            $r.Organization | Should -BeOfType [string]
        }
    }
}