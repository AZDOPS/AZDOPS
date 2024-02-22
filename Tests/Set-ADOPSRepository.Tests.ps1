param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'Set-ADOPSRepository' {
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
                Name = 'DefaultBranch'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'IsDisabled'
                Mandatory = $false
                Type = 'bool'
            },
            @{
                Name = 'NewName'
                Mandatory = $false
                Type = 'string'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command Set-ADOPSRepository | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
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

        It 'If organization is given, should not call GetADOPSDefaultOrganization' {
            $r = Set-ADOPSRepository -NewName 'NewName' -Organization 'DummyOrg' -Project 'DummyProj' -RepositoryId 'd5f24968-f2ab-4048-bd65-58711420f6fa'
            Should -Invoke -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -Times 0
        }
        It 'If organization is not given, should call GetADOPSDefaultOrganization' {
            $r = Set-ADOPSRepository -NewName 'NewName' -Project 'DummyProj' -RepositoryId 'd5f24968-f2ab-4048-bd65-58711420f6fa'
            Should -Invoke -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -Times 1
        }

        It 'Creates correct URI' {
            $required = 'https://dev.azure.com/DummyOrg/DummyProj/_apis/git/repositories/d5f24968-f2ab-4048-bd65-58711420f6fa?api-version=7.1-preview.1'
            $actual = Set-ADOPSRepository -NewName 'NewName' -Project 'DummyProj' -RepositoryId 'd5f24968-f2ab-4048-bd65-58711420f6fa'
            $actual.Uri | Should -Be $required
        }

        It 'Method sould be Patch' {
            $required = 'patch'
            $actual = Set-ADOPSRepository -NewName 'NewName' -Project 'DummyProj' -RepositoryId 'd5f24968-f2ab-4048-bd65-58711420f6fa'
            $actual.Method | Should -Be $required
        }

        It 'If no changes are input, dont do anything' {
            $actual = Set-ADOPSRepository -Project 'DummyProj' -RepositoryId 'd5f24968-f2ab-4048-bd65-58711420f6fa'
            Should -Not -Invoke -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS
            Should -Not -Invoke -CommandName InvokeADOPSRestMethod -ModuleName ADOPS
            $actual | Should -BeNullOrEmpty
        }

        It 'Verifying body, NewName' {
            $required = '{"name":"NewName"}'
            $actual = Set-ADOPSRepository -NewName 'NewName' -Project 'DummyProj' -RepositoryId 'd5f24968-f2ab-4048-bd65-58711420f6fa'
            $actual.Body | Should -Be $required
        }

        It 'Verifying body, DefaultBranch - Only branch name' {
            $required = '{"defaultBranch":"refs/heads/defBranch"}'
            $actual = Set-ADOPSRepository DefaultBranch 'defBranch' -Project 'DummyProj' -RepositoryId 'd5f24968-f2ab-4048-bd65-58711420f6fa'
            $actual.Body | Should -Be $required
        }

        It 'Verifying body, DefaultBranch - Full branch name' {
            $required = '{"defaultBranch":"refs/heads/defBranch"}'
            $actual = Set-ADOPSRepository DefaultBranch 'refs/heads/defBranch' -Project 'DummyProj' -RepositoryId 'd5f24968-f2ab-4048-bd65-58711420f6fa'
            $actual.Body | Should -Be $required
        }

        It 'Verifying body, IsDisabled:$true' {
            $required = '{"IsDisabled":true}'
            $actual = Set-ADOPSRepository -IsDisabled:$true -Project 'DummyProj' -RepositoryId 'd5f24968-f2ab-4048-bd65-58711420f6fa'
            $actual.Body | Should -Be $required
        }

        It 'Verifying body, IsDisabled:$false' {
            $required = '{"IsDisabled":false}'
            $actual = Set-ADOPSRepository -IsDisabled:$false -Project 'DummyProj' -RepositoryId 'd5f24968-f2ab-4048-bd65-58711420f6fa'
            $actual.Body | Should -Be $required
        }

        It 'Verifying body, all parameters. If IsDisabled and others are set we should invoke the API twice -IsDisabled:$true.' {
            $actual = Set-ADOPSRepository -IsDisabled:$true -NewName 'NewName' -DefaultBranch 'defBranch' -Project 'DummyProj' -RepositoryId 'd5f24968-f2ab-4048-bd65-58711420f6fa'
            $actual.Count | Should -Be 2
        }

        It 'Verifying body, all parameters. If IsDisabled and others are set we should invoke the API twice-IsDisabled:$false.' {
            $actual = Set-ADOPSRepository -IsDisabled:$false -NewName 'NewName' -DefaultBranch 'defBranch' -Project 'DummyProj' -RepositoryId 'd5f24968-f2ab-4048-bd65-58711420f6fa'
            $actual.Count | Should -Be 2
        }
    }
}