param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'New-ADOPSRepository' {
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
                Name = 'name'
                Mandatory = $true
                Type = 'string'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command New-ADOPSRepository | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }

    Context 'Running command' {
        BeforeAll {
            InModuleScope -ModuleName ADOPS {
                Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'myorg' }
                
                Mock -CommandName InvokeADOPSRestMethod  -ModuleName ADOPS -MockWith {
                    return $InvokeSplat
                }

                Mock Get-ADOPSProject -MockWith {
                    return @'
                    {
                        "id": "34f7babc-b656-4d13-bf24-bba1782d88fe",
                        "name": "DummyProject",
                        "description": "DummyProject",
                        "url": "https://dev.azure.com/DummyOrg/_apis/projects/34f7babc-b656-4d13-bf24-bba1782d88fe",
                        "state": "wellFormed",
                        "revision": 1,
                        "visibility": "private",
                    }
'@ | ConvertFrom-Json
                } -ParameterFilter { $Name -eq 'MyRepoName' }
            }
        }

        It 'If organization is not given, it should not call GetADOPSDefaultOrganization' {
            $r = New-ADOPSRepository -Organization 'DummyOrg' -Project 'DummyProj' -Name 'RepoName'
            Should -Invoke -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -Times 0 -Exactly
        }
        It 'If organization is given, it should call GetADOPSDefaultOrganization' {
            $r = New-ADOPSRepository -Project 'DummyProj' -Name 'RepoName'
            Should -Invoke -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -Times 1 -Exactly
        }
        
        It 'Invoke should be correct, Verifying method "Post"' {
            $r = New-ADOPSRepository -Organization 'DummyOrg' -Project 'DummyProj' -Name 'RepoName'
            $r.Method | Should -Be 'Post'
        }
        It 'Invoke should be correct, Verifying URI using RepositoryId' {
            $r = New-ADOPSRepository -Organization 'DummyOrg' -Project 'DummyProj' -Name 'RepoName'
            $r.URI | Should -Be 'https://dev.azure.com/DummyOrg/_apis/git/repositories?api-version=7.1-preview.1'
        }
        It 'Invoke should be correct, Verifying URL for Organization' {
            $r = New-ADOPSRepository -Organization 'AnotherOrg' -Project 'DummyProj' -Name 'RepoName'
            $r.URI | Should -Be 'https://dev.azure.com/AnotherOrg/_apis/git/repositories?api-version=7.1-preview.1'
        }
        It 'Invoke should be correct, Verifying body' {
            $res = '{"name":"MyRepoName","project":{"id":"34f7babc-b656-4d13-bf24-bba1782d88fe"}}'
            $r = New-ADOPSRepository -Project 'DummyProject' -Name 'MyRepoName'
            $r.body | Should -Be $res
        }
    }
}