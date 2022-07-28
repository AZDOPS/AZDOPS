BeforeDiscovery {
    . $PSScriptRoot\TestHelpers.ps1
    Initialize-TestSetup
}

InModuleScope -ModuleName ADOPS {
    Describe 'New-ADOPSPipeline tests' {
        It 'Has parameter <_.Name>' -TestCases @(
            @{ Name = 'Name'; Mandatory = $true }
            @{ Name = 'Project'; Mandatory = $true }
            @{ Name = 'YamlPath'; Mandatory = $true }
            @{ Name = 'Repository'; Mandatory = $true }
            @{ Name = 'FolderPath'; }
            @{ Name = 'Organization'; }
        ) {
            Get-Command -Name New-ADOPSPipeline | Should -HaveParameterStrict $Name -Mandatory:([bool]$Mandatory) -Type $Type
        }
        Context 'Creating Pipeline' {
            BeforeAll {

                $OrganizationName = 'DummyOrg'
                $Project = 'DummyProject'
                $PipeName = 'DummyPipe1'
                $YamlPath = 'DummyYamlPath/file.yaml'
                $Repository = 'DummyRepo'

                Mock -CommandName GetADOPSHeader -ModuleName ADOPS -MockWith {
                    @{
                        Header       = @{
                            'Authorization' = 'Basic Base64=='
                        }
                        Organization = $OrganizationName
                    }
                } -ParameterFilter { $OrganizationName -eq $OrganizationName }
                Mock -CommandName GetADOPSHeader -ModuleName ADOPS -MockWith {
                    @{
                        Header       = @{
                            'Authorization' = 'Basic Base64=='
                        }
                        Organization = $OrganizationName
                    }
                }

                Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                    return $InvokeSplat
                } -ParameterFilter { $method -eq 'Post' }
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
            It 'returns output after getting pipeline' {
                New-ADOPSPipeline -Organization $OrganizationName -Project $Project -Name $PipeName -YamlPath $YamlPath -Repository $Repository | Should -BeOfType [pscustomobject] -Because 'InvokeADOPSRestMethod should convert the json to pscustomobject'
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
            It 'should not throw without optional parameters' {
                { New-ADOPSPipeline -Project $Project -Name $PipeName -YamlPath $YamlPath -Repository $Repository} | Should -Not -Throw
            }
        }
    }
}