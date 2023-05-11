param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'New-ADOPSPipeline' {
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
                Name = 'Name'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'YamlPath'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'Repository'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'FolderPath'
                Mandatory = $false
                Type = 'string'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command New-ADOPSPipeline | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }

    Context 'Creating Pipeline' {
        BeforeAll {
            $OrganizationName = 'DummyOrg'
            $Project = 'DummyProject'
            $PipeName = 'DummyPipe1'
            $YamlPath = 'DummyYamlPath/file.yaml'
            $Repository = 'DummyRepo'

            Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'myorg' }
            
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {}
            
            Mock -CommandName Get-ADOPSRepository -ModuleName ADOPS -MockWith {
                throw
            } -ParameterFilter { $Repository -eq 'MissingRepo' }
            
            Mock -CommandName Get-ADOPSRepository -ModuleName ADOPS -MockWith {
                return @'
                {
                    "id": "39956c9b-d818-4338-8d99-f5e6004bdb72",
                    "name": "DummyRepo",
                    "url": "https://dev.azure.com/OrganizationName/Project/_apis/git/repositories/39956c9b-d818-4338-8d99-f5e6004bdb72",
                    "project": {
                        "id": "39956c9b-d818-4338-8d99-f5e6004bdb73",
                        "name": "DummyProject",
                        "url": "https://dev.azure.com/OrganizationName/_apis/projects/Project",
                        "state": "wellFormed",
                        "visibility": "private"
                    },
                    "defaultBranch": "refs/heads/main",
                    "remoteUrl": "https://OrganizationName@dev.azure.com/OrganizationName/DummyRepo/_git/DummyRepo",
                    "sshUrl": "git@ssh.dev.azure.com:v3/OrganizationName/DummyRepo/DummyRepo",
                    "webUrl": "https://dev.azure.com/OrganizationName/DummyRepo/_git/DummyRepo",
                    "_links": {
                        "self": {
                            "href": "https://dev.azure.com/OrganizationName/Project/_apis/git/repositories/39956c9b-d818-4338-8d99-f5e6004bdb72"
                        }
                    },
                    "isDisabled": false
                }
'@ | ConvertFrom-Json
            }
        }

        
        It 'uses InvokeADOPSRestMethod one time' {
            New-ADOPSPipeline -Organization $OrganizationName -Project $Project -Name $PipeName -YamlPath $YamlPath -Repository $Repository
            Should -Invoke 'InvokeADOPSRestMethod' -ModuleName 'ADOPS' -Exactly -Times 1
        }
        
        It 'uses Get-ADOPSRepository one time' {
            New-ADOPSPipeline -Organization $OrganizationName -Project $Project -Name $PipeName -YamlPath $YamlPath -Repository $Repository
            Should -Invoke 'Get-ADOPSRepository' -ModuleName 'ADOPS' -Exactly -Times 1
        }

        It 'should not throw with mandatory parameters' {
            { New-ADOPSPipeline -Organization $OrganizationName -Project $Project -Name $PipeName -YamlPath $YamlPath -Repository $Repository} | Should -Not -Throw
        }
        
        It 'should throw if Repository Name is invalid' {
            { New-ADOPSPipeline -Organization $OrganizationName -Project $Project -Name $PipeName -YamlPath $YamlPath -Repository 'MissingRepo'} | Should -Throw
        }
        
        It 'should throw if YamlPath dont contain *.yaml' {
            { New-ADOPSPipeline -Organization $OrganizationName -Project $Project -Name $PipeName -YamlPath 'MissingYamlPath' -Repository $Repository} | Should -Throw
        }
        
        It 'should not throw if YamlPath is *.yml' {
            {New-ADOPSPipeline -Organization $OrganizationName -Project $Project -Name $PipeName -YamlPath '.path/to/mePipeline.yml' -Repository $Repository} | Should -Not -Throw
        }

        It 'should not throw without optional parameters' {
            { New-ADOPSPipeline -Project $Project -Name $PipeName -YamlPath $YamlPath -Repository $Repository} | Should -Not -Throw
        }
        
        It 'Verify body' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $body
            } -ParameterFilter { $method -eq 'Post' }

            $r = New-ADOPSPipeline -Organization $OrganizationName -Project $Project -Name $PipeName -YamlPath $YamlPath -Repository $Repository
            $r | Should -Be '{"name":"DummyPipe1","folder":"\\","configuration":{"type":"yaml","path":"DummyYamlPath/file.yaml","repository":{"id":"39956c9b-d818-4338-8d99-f5e6004bdb72","type":"azureReposGit"}}}'
        }
                
        It 'Verify uri' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $uri
            } -ParameterFilter { $method -eq 'Post' }

            $r = New-ADOPSPipeline -Organization $OrganizationName -Project $Project -Name $PipeName -YamlPath $YamlPath -Repository $Repository
            $r | Should -Be 'https://dev.azure.com/DummyOrg/DummyProject/_apis/pipelines?api-version=7.1-preview.1'
        }
    }

}
 