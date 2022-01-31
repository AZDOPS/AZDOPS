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
    }

    Context 'Starting pipeline' {
        BeforeAll {
            $script:AzDOOrganization = 'dummyorg'

            function InvokeAZDevOPSRestMethod {}
            Mock -CommandName 'InvokeAZDevOPSRestMethod' -MockWith {
                '{"count":2,"value":[{"_links":{"self":{"href":"https://dev.azure.com/dummyorg/9ca5975f-7615-4f60-927d-d9222b095544/_apis/pipelines/1?revision=1"},"web":{"href":"https://dev.azure.com/dummyorg/9ca5975f-7615-4f60-927d-d9222b095544/_build/definition?definitionId=1"}},"url":"https://dev.azure.com/dummyorg/9ca5975f-7615-4f60-927d-d9222b095544/_apis/pipelines/1?revision=1","id":1,"revision":1,"name":"dummypipeline1","folder":"\\"},{"_links":{"self":{"href":"https://dev.azure.com/dummyorg/9ca5975f-7615-4f60-927d-d9222b095544/_apis/pipelines/3?revision=1"},"web":{"href":"https://dev.azure.com/dummyorg/9ca5975f-7615-4f60-927d-d9222b095544/_build/definition?definitionId=3"}},"url":"https://dev.azure.com/dummyorg/9ca5975f-7615-4f60-927d-d9222b095544/_apis/pipelines/3?revision=1","id":3,"revision":1,"name":"ummypipeline2","folder":"\\"}]}' | ConvertFrom-Json     
            }
        }

        It 'Should call mock' {
            Start-AZDevOPSPipeline -Name 'DummyPipeline' -Project 'DummyProject'
            Should -Invoke 'InvokeAZDevOPSRestMethod' -Exactly 2
        }
    }
}