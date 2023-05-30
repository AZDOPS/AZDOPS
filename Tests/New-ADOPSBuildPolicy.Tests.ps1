param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'New-ADOPSBuildPolicy' {
    Context 'Parameters' {
        $TestCases = @(
            @{
                Name = 'Organization'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'Project'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'RepositoryId'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'Branch'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'PipelineId'
                Mandatory = $true
                Type = 'int'
            },
            @{
                Name = 'Displayname'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'filenamePatterns'
                Mandatory = $false
                Type = 'string[]'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command New-ADOPSBuildPolicy | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }

    
    Context "Functionality" {
        BeforeAll {
            InModuleScope -ModuleName ADOPS {
                Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'DummyOrg' }
                
                Mock -CommandName InvokeADOPSRestMethod  -ModuleName ADOPS -MockWith {
                    return $InvokeSplat
                }
            }
        }

        It 'If organization is given, it should not call GetADOPSDefaultOrganization' {
            $r = New-ADOPSBuildPolicy -Organization 'DummyOrg' -Project 'DummyProj' -RepositoryId 1 -Branch 'main' -PipelineId 1 -Displayname 'dummyPolicy'
            Should -Invoke -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -Times 0 -Exactly
        }
        It 'If organization is not given, it should call GetADOPSDefaultOrganization' {
            $r = New-ADOPSBuildPolicy -Project 'DummyProj' -RepositoryId 1 -Branch 'main' -PipelineId 1 -Displayname 'dummyPolicy'
            Should -Invoke -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -Times 1 -Exactly
        }

        
        It 'Creates correct URI' {
            $required = 'https://dev.azure.com/DummyOrg/DummyProj/_apis/policy/configurations?api-version=7.1-preview.1'
            $actual = New-ADOPSBuildPolicy -Project 'DummyProj' -RepositoryId 1 -Branch 'main' -PipelineId 1 -Displayname 'dummyPolicy'
            $actual.Uri | Should -Be $required
        }

        It 'Method is POST' {
            $required = 'POST'
            $actual = New-ADOPSBuildPolicy -Project 'DummyProj' -RepositoryId 1 -Branch 'main' -PipelineId 1 -Displayname 'dummyPolicy'
            $actual.Method | Should -Be $required
        }

        It 'Verifying body, no filenamepatterns given, only branch name' {
            $required = '{"type":{"id":"0609b952-1397-4640-95ec-e00a01b2c241"},"isBlocking":true,"isEnabled":true,"settings":{"scope":[{"repositoryId":"1","refName":"refs/heads/main","matchKind":"exact"}],"buildDefinitionId":"1","queueOnSourceUpdateOnly":false,"manualQueueOnly":false,"displayName":"dummyPolicy","validDuration":"0"}}'
            $actual = New-ADOPSBuildPolicy -Project 'DummyProj' -RepositoryId 1 -Branch 'main' -PipelineId 1 -Displayname 'dummyPolicy'
            $actual.Body | Should -Be $required
        }

        It 'Verifying body, no filenamepatterns given, full branch name' {
            $required = '{"type":{"id":"0609b952-1397-4640-95ec-e00a01b2c241"},"isBlocking":true,"isEnabled":true,"settings":{"scope":[{"repositoryId":"1","refName":"refs/heads/main","matchKind":"exact"}],"buildDefinitionId":"1","queueOnSourceUpdateOnly":false,"manualQueueOnly":false,"displayName":"dummyPolicy","validDuration":"0"}}'
            $actual = New-ADOPSBuildPolicy -Project 'DummyProj' -RepositoryId 1 -Branch 'refs/heads/main' -PipelineId 1 -Displayname 'dummyPolicy'
            $actual.Body | Should -Be $required
        }
        
        It 'Verifying body, single filenamepatterns given, only branch name' {
            $required = '{"type":{"id":"0609b952-1397-4640-95ec-e00a01b2c241"},"isBlocking":true,"isEnabled":true,"settings":{"scope":[{"repositoryId":"1","refName":"refs/heads/main","matchKind":"exact"}],"buildDefinitionId":"1","queueOnSourceUpdateOnly":false,"manualQueueOnly":false,"displayName":"dummyPolicy","validDuration":"0","filenamePatterns":["/root/*"]}}'
            $actual = New-ADOPSBuildPolicy -Project 'DummyProj' -RepositoryId 1 -Branch 'main' -PipelineId 1 -Displayname 'dummyPolicy' -filenamePatterns '/root/*'
            $actual.Body | Should -Be $required
        }

        It 'Verifying body, single filenamepatterns given, full branch name' {
            $required = '{"type":{"id":"0609b952-1397-4640-95ec-e00a01b2c241"},"isBlocking":true,"isEnabled":true,"settings":{"scope":[{"repositoryId":"1","refName":"refs/heads/main","matchKind":"exact"}],"buildDefinitionId":"1","queueOnSourceUpdateOnly":false,"manualQueueOnly":false,"displayName":"dummyPolicy","validDuration":"0","filenamePatterns":["/root/*"]}}'
            $actual = New-ADOPSBuildPolicy -Project 'DummyProj' -RepositoryId 1 -Branch 'refs/heads/main' -PipelineId 1 -Displayname 'dummyPolicy' -filenamePatterns '/root/*'
            $actual.Body | Should -Be $required
        }
        
        It 'Verifying body, multiple filenamepatterns given, only branch name' {
            $required = '{"type":{"id":"0609b952-1397-4640-95ec-e00a01b2c241"},"isBlocking":true,"isEnabled":true,"settings":{"scope":[{"repositoryId":"1","refName":"refs/heads/main","matchKind":"exact"}],"buildDefinitionId":"1","queueOnSourceUpdateOnly":false,"manualQueueOnly":false,"displayName":"dummyPolicy","validDuration":"0","filenamePatterns":["/root/*","/side/*"]}}'
            $actual = New-ADOPSBuildPolicy -Project 'DummyProj' -RepositoryId 1 -Branch 'main' -PipelineId 1 -Displayname 'dummyPolicy' -filenamePatterns '/root/*','/side/*'
            $actual.Body | Should -Be $required
        }

        It 'Verifying body, multiple filenamepatterns given, full branch name' {
            $required = '{"type":{"id":"0609b952-1397-4640-95ec-e00a01b2c241"},"isBlocking":true,"isEnabled":true,"settings":{"scope":[{"repositoryId":"1","refName":"refs/heads/main","matchKind":"exact"}],"buildDefinitionId":"1","queueOnSourceUpdateOnly":false,"manualQueueOnly":false,"displayName":"dummyPolicy","validDuration":"0","filenamePatterns":["/root/*","/side/*"]}}'
            $actual = New-ADOPSBuildPolicy -Project 'DummyProj' -RepositoryId 1 -Branch 'refs/heads/main' -PipelineId 1 -Displayname 'dummyPolicy' -filenamePatterns '/root/*','/side/*'
            $actual.Body | Should -Be $required
        }
    }
}