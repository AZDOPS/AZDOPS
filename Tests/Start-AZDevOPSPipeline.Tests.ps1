Remove-Module AZDevOPS -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot\..\Source\AZDevOPS

Describe 'Start-AZDevOPSPipeline' {
    Context 'Parameters' {
        It 'Should have parameter Name' {
            (Get-Command Start-AZDevOPSPipeline).Parameters.Keys | Should -Contain 'Name'
        }
        It 'Name should be mandatory' {
            (Get-Command Start-AZDevOPSPipeline).Parameters['Name'].Attributes.Mandatory | Should -Be $true
        }

        It 'Should have parameter Project' {
            (Get-Command Start-AZDevOPSPipeline).Parameters.Keys | Should -Contain 'Project'
        }
        It 'Project should be mandatory' {
            (Get-Command Start-AZDevOPSPipeline).Parameters['Project'].Attributes.Mandatory | Should -Be $true
        }

        It 'Should have parameter Organization' {
            (Get-Command Start-AZDevOPSPipeline).Parameters.Keys | Should -Contain 'Organization'
        }

        It 'Should have parameter Branch' {
            (Get-Command Start-AZDevOPSPipeline).Parameters.Keys | Should -Contain 'Branch'
        }
    }

    Context 'Starting pipeline' {
        BeforeAll {
            InModuleScope -ModuleName AZDevOps {
                Mock -CommandName GetAZDevOPSHeader -ModuleName AZDevOPS -MockWith {
                    @{
                        Header       = @{
                            'Authorization' = 'Basic Base64=='
                        }
                        Organization = 'DummyOrg'
                    }
                } -ParameterFilter { $Organization -eq 'Organization' }
                Mock -CommandName GetAZDevOPSHeader -ModuleName AZDevOPS -MockWith {
                    @{
                        Header       = @{
                            'Authorization' = 'Basic Base64=='
                        }
                        Organization = 'DummyOrg'
                    }
                }

                Mock -CommandName InvokeAZDevOPSRestMethod -ModuleName AZDevOPS -MockWith {
                    '{"count":2,"value":[{"_links":{"self":{"href":"https://dev.azure.com/dummyorg/9ca5975f-7615-4f60-927d-d9222b095544/_apis/pipelines/1?revision=1"},"web":{"href":"https://dev.azure.com/dummyorg/9ca5975f-7615-4f60-927d-d9222b095544/_build/definition?definitionId=1"}},"url":"https://dev.azure.com/dummyorg/9ca5975f-7615-4f60-927d-d9222b095544/_apis/pipelines/1?revision=1","id":1,"revision":1,"name":"dummypipeline1","folder":"\\"},{"_links":{"self":{"href":"https://dev.azure.com/dummyorg/9ca5975f-7615-4f60-927d-d9222b095544/_apis/pipelines/3?revision=1"},"web":{"href":"https://dev.azure.com/dummyorg/9ca5975f-7615-4f60-927d-d9222b095544/_build/definition?definitionId=3"}},"url":"https://dev.azure.com/dummyorg/9ca5975f-7615-4f60-927d-d9222b095544/_apis/pipelines/3?revision=1","id":3,"revision":1,"name":"ummypipeline2","folder":"\\"}]}' | ConvertFrom-Json     
                } -ParameterFilter { $method -eq 'Get' }

                Mock -CommandName InvokeAZDevOPSRestMethod -ModuleName AZDevOPS -MockWith {
                    return $InvokeSplat
                } -ParameterFilter { $method -eq 'post' }
            }
        }

        It 'Should call mock InvokeAZDevOPSRestMethod' {
            Start-AZDevOPSPipeline -Name 'DummyPipeline1' -Project 'DummyProject'
            Should -Invoke 'InvokeAZDevOPSRestMethod' -ModuleName 'AZDevOPS' -Exactly -Times 2
        }
        It 'If no organization is passed, Get default' {
            Start-AZDevOPSPipeline -Name 'DummyPipeline1' -Project 'DummyProject'
            Should -Invoke 'GetAZDevOPSHeader' -ModuleName 'AZDevOPS' -Exactly -Times 1
        }

        It 'If an organization is passed, that organization should be used for URI' {
            Start-AZDevOPSPipeline -Name 'DummyPipeline1' -Project 'DummyProject' -Organization 'Organization'
            Should -Invoke 'GetAZDevOPSHeader' -ModuleName 'AZDevOPS' -Exactly -Times 1 -ParameterFilter { $Organization -eq 'Organization' }
        }
        It 'If no pipeline with correct name is found we should throw error' {
            { Start-AZDevOPSPipeline -Name 'NonExistingPipeline' -Project 'DummyProject' -Organization 'Organization' } | Should -Throw
        }

        It 'Uri should be set correct' {
            $r = Start-AZDevOPSPipeline -Name 'DummyPipeline1' -Project 'DummyProject'
            $r.Uri | Should -Be 'https://dev.azure.com/DummyOrg/DummyProject/_apis/pipelines/1/runs?api-version=7.1-preview.1'
        }
        It 'Method should be post' {
            $r = Start-AZDevOPSPipeline -Name 'DummyPipeline1' -Project 'DummyProject'
            $r.Method | Should -Be 'post'
        }
        It 'Body should be set with branch name. If no branch is given, "main"' {
            $r = Start-AZDevOPSPipeline -Name 'DummyPipeline1' -Project 'DummyProject'
            $r.Body | Should -BeLike '*main*'
        }
        It 'Body should be set with branch name If branch is given as parameter, "branch"' {
            $r = Start-AZDevOPSPipeline -Name 'DummyPipeline1' -Project 'DummyProject' -Branch 'branch'
            $r.Body | Should -BeLike '*branch*'
        }
        It 'Organization should be of type string' {
            $r = Start-AZDevOPSPipeline -Name 'DummyPipeline1' -Project 'DummyProject' -Branch 'branch'
            $r.Organization | Should -BeOfType [string]
        }
    }
}