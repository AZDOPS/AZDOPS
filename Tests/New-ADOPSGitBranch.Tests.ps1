param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'New-ADOPSGitBranch' {
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
                Name = 'BranchName'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'CommitId'
                Mandatory = $true
                Type = 'string'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command New-ADOPSGitBranch | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
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
            $r = New-ADOPSGitBranch -Organization 'DummyOrg' -Project 'DummyProj' -RepositoryId 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' -BranchName 'myNewBranch' -CommitId 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
            Should -Invoke -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -Times 0 -Exactly
        }
        It 'If organization is not given, in should call GetADOPSDefaultOrganization' {
            $r = New-ADOPSGitBranch -Project 'DummyProj' -RepositoryId 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' -BranchName 'myNewBranch' -CommitId 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
            Should -Invoke -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -Times 1 -Exactly
        }

        It 'Creates correct URI' {
            $required = "https://dev.azure.com/DummyOrg/DummyProj/_apis/git/repositories/aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/refs?api-version=7.1-preview.1"
            $actual = New-ADOPSGitBranch -Project 'DummyProj' -RepositoryId 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' -BranchName 'myNewBranch' -CommitId 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
            $actual.Uri | Should -Be $required
        }

        It 'Method sould be Post' {
            $required = 'Post'
            $actual = New-ADOPSGitBranch -Project 'DummyProj' -RepositoryId 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' -BranchName 'myNewBranch' -CommitId 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
            $actual.Method | Should -Be $required
        }

        It 'Verifying body' {
            $required = '[{"name":"refs/heads/myNewBranch","oldObjectId":"0000000000000000000000000000000000000000","newObjectId":"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"}]'
            $actual = New-ADOPSGitBranch -Project 'DummyProj' -RepositoryId 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' -BranchName 'myNewBranch' -CommitId 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
            $actual.Body | Should -Be $required
        }

        It 'If CommitId is to short, it should throw' {
            {New-ADOPSGitBranch -Project 'DummyProj' -RepositoryId 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' -BranchName 'myNewBranch' -CommitId 'aaaaaaa'} | Should -Throw -Because 'We need the full commit ID hash, not just the short version'
        }

        It 'RepoID must be GUID style' {
            {New-ADOPSGitBranch -Project 'DummyProj' -RepositoryId 'NotAGuid' -BranchName 'myNewBranch' -CommitId 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'} | Should -Throw
        }
    }
}
