BeforeDiscovery {
    . $PSScriptRoot\TestHelpers.ps1
    Initialize-TestSetup
}

Describe 'Import-ADOPSRepository' {
    Context 'Parameter validation' {
        BeforeAll {
            $command  = Get-Command -Name Import-ADOPSRepository -Module ADOPS
        }
        It 'Has parameter <_.Name>' -TestCases @(
            @{ Name = 'GitSource'; Mandatory = $true }
            @{ Name = 'RepositoryId'; Mandatory = $true }
            @{ Name = 'RepositoryName'; Mandatory = $true }
            @{ Name = 'Project'; Mandatory = $true }
            @{ Name = 'Organization'; }
        ) {
            $command | Should -HaveParameterStrict $Name -Mandatory:([bool]$Mandatory) -Type $Type
        }
        It 'GitSource parameter should be in all parametersets: <_>' -TestCases $command.ParameterSets.Name {
            $command.Parameters['GitSource'].ParameterSets.Keys | Should -Contain $_
        }
        It 'Organization parameter should be in all parametersets: <_>' -TestCases $command.ParameterSets.Name {
            $command.Parameters['Organization'].ParameterSets.Keys | Should -Contain $_
        }
        It 'Project parameter should be in all parametersets: <_>' -TestCases $command.ParameterSets.Name {
            $command.Parameters['Project'].ParameterSets.Keys | Should -Contain $_
        }
        It 'RepositoryId parameter should only be in RepositoryId ParameterSet' {
            $command.Parameters['RepositoryID'].ParameterSets.Keys | Should -Be 'RepositoryId'
        }
        It 'RepositoryName parameter should only be in RepositoryName ParameterSet' {
            $command.Parameters['RepositoryName'].ParameterSets.Keys | Should -Be 'RepositoryName'
        }
        It 'Default ParameterSet should be "RepositoryName"' {
            $command.DefaultParameterSet | Should -Be 'RepositoryName'
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