param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'New-ADOPSMergePolicy' {
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
                Name = 'allowNoFastForward'
                Mandatory = $false
                Type = 'switch'
            },
            @{
                Name = 'allowSquash'
                Mandatory = $false
                Type = 'switch'
            },
            @{
                Name = 'allowRebase'
                Mandatory = $false
                Type = 'switch'
            },
            @{
                Name = 'allowRebaseMerge'
                Mandatory = $false
                Type = 'switch'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command New-ADOPSMergePolicy | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
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
            $r = New-ADOPSMergePolicy -Organization 'DummyOrg' -Project 'DummyProj' -RepositoryId 1 -Branch 'main'
            Should -Invoke -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -Times 0 -Exactly
        }
        It 'If organization is not given, it should call GetADOPSDefaultOrganization' {
            $r = New-ADOPSMergePolicy -Project 'DummyProj' -RepositoryId 1 -Branch 'main'
            Should -Invoke -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -Times 1 -Exactly
        }
        
        It 'Creates correct URI' {
            $required = 'https://dev.azure.com/DummyOrg/DummyProj/_apis/policy/configurations?api-version=7.1-preview.1'
            $actual = New-ADOPSMergePolicy -Project 'DummyProj' -RepositoryId 1 -Branch 'main'
            $actual.Uri | Should -Be $required
        }

        It 'Method is POST' {
            $required = 'POST'
            $actual = New-ADOPSMergePolicy -Project 'DummyProj' -RepositoryId 1 -Branch 'main'
            $actual.Method | Should -Be $required
        }

        It 'Verifying body, allowing nothing' {
            $required = '{"type":{"id":"fa4e907d-c16b-4a4c-9dfa-4916e5d171ab"},"isBlocking":true,"isEnabled":true,"settings":{"scope":[{"repositoryId":"1","refName":"refs/heads/main","matchKind":"exact"}],"allowNoFastForward":false,"allowSquash":false,"allowRebase":false,"allowRebaseMerge":false}}'
            $actual = New-ADOPSMergePolicy -Project 'DummyProj' -RepositoryId 1 -Branch 'main'
            $actual.Body | Should -Be $required
        }

        It 'Verifying body, allowing allowNoFastForward' {
            $required = '{"type":{"id":"fa4e907d-c16b-4a4c-9dfa-4916e5d171ab"},"isBlocking":true,"isEnabled":true,"settings":{"scope":[{"repositoryId":"1","refName":"refs/heads/main","matchKind":"exact"}],"allowNoFastForward":true,"allowSquash":false,"allowRebase":false,"allowRebaseMerge":false}}'
            $actual = New-ADOPSMergePolicy -Project 'DummyProj' -RepositoryId 1 -Branch 'main' -allowNoFastForward
            $actual.Body | Should -Be $required
        }

        It 'Verifying body, allowing allowSquash' {
            $required = '{"type":{"id":"fa4e907d-c16b-4a4c-9dfa-4916e5d171ab"},"isBlocking":true,"isEnabled":true,"settings":{"scope":[{"repositoryId":"1","refName":"refs/heads/main","matchKind":"exact"}],"allowNoFastForward":false,"allowSquash":true,"allowRebase":false,"allowRebaseMerge":false}}'
            $actual = New-ADOPSMergePolicy -Project 'DummyProj' -RepositoryId 1 -Branch 'main' -allowSquash
            $actual.Body | Should -Be $required
        }

        It 'Verifying body, allowing allowRebase' {
            $required = '{"type":{"id":"fa4e907d-c16b-4a4c-9dfa-4916e5d171ab"},"isBlocking":true,"isEnabled":true,"settings":{"scope":[{"repositoryId":"1","refName":"refs/heads/main","matchKind":"exact"}],"allowNoFastForward":false,"allowSquash":false,"allowRebase":true,"allowRebaseMerge":false}}'
            $actual = New-ADOPSMergePolicy -Project 'DummyProj' -RepositoryId 1 -Branch 'main' -allowRebase
            $actual.Body | Should -Be $required
        }

        It 'Verifying body, allowing allowRebaseMerge' {
            $required = '{"type":{"id":"fa4e907d-c16b-4a4c-9dfa-4916e5d171ab"},"isBlocking":true,"isEnabled":true,"settings":{"scope":[{"repositoryId":"1","refName":"refs/heads/main","matchKind":"exact"}],"allowNoFastForward":false,"allowSquash":false,"allowRebase":false,"allowRebaseMerge":true}}'
            $actual = New-ADOPSMergePolicy -Project 'DummyProj' -RepositoryId 1 -Branch 'main' -allowRebaseMerge
            $actual.Body | Should -Be $required
        }
        
        It 'Verifying body, allowing all' {
            $required = '{"type":{"id":"fa4e907d-c16b-4a4c-9dfa-4916e5d171ab"},"isBlocking":true,"isEnabled":true,"settings":{"scope":[{"repositoryId":"1","refName":"refs/heads/main","matchKind":"exact"}],"allowNoFastForward":true,"allowSquash":true,"allowRebase":true,"allowRebaseMerge":true}}'
            $actual = New-ADOPSMergePolicy -Project 'DummyProj' -RepositoryId 1 -Branch 'main' -allowNoFastForward -allowSquash -allowRebase -allowRebaseMerge
            $actual.Body | Should -Be $required
        }
    }
}