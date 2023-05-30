param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'Import-ADOPSRepository' {
    Context 'Parameters' {
        BeforeAll {
            $r  = Get-Command -Name Import-ADOPSRepository -Module ADOPS
        }

        $TestCases = @(
            @{
                Name = 'GitSource'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'RepositoryId'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'RepositoryName'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'Project'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'wait'
                Mandatory = $false
                Type = 'switch'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command Import-ADOPSRepository | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
        
        It 'GitSource parameter should be in all parametersets: <_>' -TestCases $r.ParameterSets.Name {
            $r.Parameters['GitSource'].ParameterSets.Keys | Should -Contain $_
        }
        It 'Organization parameter should be in all parametersets: <_>' -TestCases $r.ParameterSets.Name {
            $r.Parameters['Organization'].ParameterSets.Keys | Should -Contain $_
        }
        It 'Project parameter should be in all parametersets: <_>' -TestCases $r.ParameterSets.Name {
            $r.Parameters['Project'].ParameterSets.Keys | Should -Contain $_
        }
        It 'RepositoryId parameter should only be in RepositoryId ParameterSet' {
            $r.Parameters['RepositoryID'].ParameterSets.Keys | Should -Be 'RepositoryId'
        }
        It 'RepositoryName parameter should only be in RepositoryName ParameterSet' {
            $r.Parameters['RepositoryName'].ParameterSets.Keys | Should -Be 'RepositoryName'
        }
        It 'Default ParameterSet should be "RepositoryName"' {
            $r.DefaultParameterSet | Should -Be 'RepositoryName'
        }
    }

    Context 'Running command' {
        BeforeAll {
            InModuleScope -ModuleName ADOPS {
                Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'DummyOrg' }
                
                Mock -CommandName InvokeADOPSRestMethod  -ModuleName ADOPS -MockWith {
                    return $InvokeSplat
                }
            }
        }

        It 'If organization is given, it should not call GetADOPSDefaultOrganization' {
            $r = Import-ADOPSRepository -Organization 'Organization' -GitSource 'GitSource' -RepositoryName 'RepoName' -Project 'DummyProj'
            Should -Invoke -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -Times 0 -Exactly
        }
        It 'If organization is not given, it should call GetADOPSDefaultOrganization' {
            $r = Import-ADOPSRepository -GitSource 'GitSource' -RepositoryName 'RepoName' -Project 'DummyProj'
            Should -Invoke -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -Times 1 -Exactly
        }
        
        It 'Invoke should be correct, Verifying method "Post"' {
            $r = Import-ADOPSRepository -GitSource 'GitSource' -RepositoryName 'RepoName' -Project 'DummyProj'
            $r.Method | Should -Be 'Post'
        }
        It 'Invoke should be correct, Verifying URI using RepositoryName' {
            $r = Import-ADOPSRepository -Organization 'Organization' -GitSource 'GitSource' -RepositoryName 'RepoName' -Project 'DummyProj'
            $r.URI | Should -Be 'https://dev.azure.com/Organization/DummyProj/_apis/git/repositories/RepoName/importRequests?api-version=7.1-preview.1'
        }
        It 'Invoke should be correct, Verifying URI using RepositoryId' {
            $r = Import-ADOPSRepository -Organization 'Organization' -GitSource 'GitSource' -RepositoryId 'RepoId' -Project 'DummyProj'
            $r.URI | Should -Be 'https://dev.azure.com/Organization/DummyProj/_apis/git/repositories/RepoId/importRequests?api-version=7.1-preview.1'
        }
        It 'Invoke should be correct, Verifying URI without Organization' {
            $r = Import-ADOPSRepository -GitSource 'GitSource' -RepositoryId 'RepoId' -Project 'DummyProj'
            $r.URI | Should -Be 'https://dev.azure.com/DummyOrg/DummyProj/_apis/git/repositories/RepoId/importRequests?api-version=7.1-preview.1'
        }
        It 'Invoke should be correct, Verifying body' {
            $res = '{"parameters":{"gitSource":{"url":"https://gituri.git"}}}'
            $r = Import-ADOPSRepository -Organization 'Organization' -GitSource 'https://gituri.git' -RepositoryId 'RepoId' -Project 'DummyProj'
            $r.body | Should -Be $res
        }
        
        It 'if wait is defined, waits until status is "completed"' {
            InModuleScope -ModuleName ADOPS {
                Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                    @{
                        importRequestId = 1
                        repository = @{
                        id = "00000000-0000-0000-0000-000000000000"
                        }
                        status = "queued"
                        url = "https://dev.azure.com/DummyOrg/_apis/git/repositories/11111111-1111-1111-1111-111111111111/importRequests/1"
                    }                  
                } -ParameterFilter { $Method -eq 'Post' }

                Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                    @{
                        importRequestId = 1
                        repository = @{
                            id = "00000000-0000-0000-0000-000000000000"
                        }
                        status = "completed"
                        url = "https://dev.azure.com/DummyOrg/_apis/git/repositories/11111111-1111-1111-1111-111111111111/importRequests/1"
                    }  
                } -ParameterFilter { $Method -eq 'Get' }
            }

            Mock -CommandName Start-Sleep -ModuleName ADOPS -MockWith {}
            
            $r = Import-ADOPSRepository -Organization 'Organization' -GitSource 'GitSource' -RepositoryId 'RepoId' -Project 'DummyProj' -Wait
            $r.status | Should -Be 'completed'
        }
    }
}