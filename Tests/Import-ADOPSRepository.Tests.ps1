Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot\..\Source\ADOPS -Force

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
                Name = 'Organization'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'Project'
                Mandatory = $true
                Type = 'string'
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
                Mock -CommandName GetADOPSHeader -ModuleName ADOPS -MockWith {
                    @{
                        Header       = @{
                            'Authorization' = 'Basic Base64=='
                        }
                        Organization = $Organization
                    }
                } -ParameterFilter { $Organization }
                Mock -CommandName GetADOPSHeader -ModuleName ADOPS -MockWith {
                    @{
                        Header       = @{
                            'Authorization' = 'Basic Base64=='
                        }
                        Organization = 'DummyOrg'
                    }
                }
                
                Mock -CommandName InvokeADOPSRestMethod  -ModuleName ADOPS -MockWith {
                    return $InvokeSplat
                }
            }
        }

        It 'If organization is given, in should call GetADOPSHeader with organization name' {
            $r = Import-ADOPSRepository -Organization 'Organization' -GitSource 'GitSource' -RepositoryName 'RepoName' -Project 'DummyProj'
            Should -Invoke -CommandName GetADOPSHeader -ModuleName ADOPS -ParameterFilter { $Organization }
        }
        It 'If organization is not given, in should call GetADOPSHeader with no parameters' {
            $r = Import-ADOPSRepository -GitSource 'GitSource' -RepositoryName 'RepoName' -Project 'DummyProj'
            Should -Invoke -CommandName GetADOPSHeader -ModuleName ADOPS
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
        It 'Invoke should be correct, Verifying body' {
            $res = '{"parameters":{"gitSource":{"url":"https://gituri.git"}}}'
            $r = Import-ADOPSRepository -Organization 'Organization' -GitSource 'https://gituri.git' -RepositoryId 'RepoId' -Project 'DummyProj'
            $r.body | Should -Be $res
        }
        It 'Invoke should be correct, Verifying Organization' {
            $r = Import-ADOPSRepository -Organization 'Organization' -GitSource 'GitSource' -RepositoryId 'RepoId' -Project 'DummyProj'
            $r.Organization | Should -Be 'Organization'
        }
    }
}