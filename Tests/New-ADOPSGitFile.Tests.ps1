param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'New-ADOPSGitFile' {
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
                Name = 'Repository'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'File'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'FileName'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'Path'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'CommitMessage'
                Mandatory = $false
                Type = 'string'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command New-ADOPSGitFile | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }

    
    Context "Functionality" {
        BeforeAll {
            InModuleScope -ModuleName ADOPS {
                Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'DummyOrg' }
                
                Mock -CommandName InvokeADOPSRestMethod  -ModuleName ADOPS -MockWith {
                    return $InvokeSplat
                }

                Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                    '{"value": {"objectId": "dd4d4ddd-4d44-44dd-44d4-4dddd44d4444"} }' | ConvertFrom-Json
                } -ParameterFilter {
                    $Uri -eq 'https://dev.azure.com/dummyOrg/2222cccc-22c2-2222-22cc-2222c22c222c/_apis/git/repositories/1a1aaaa1-aa1a-1a11-1111-11111aa11a1a/refs?filter=heads/main&includeStatuses=true&latestStatusesOnly=true&api-version=7.2-preview.2'
                }
            }
            Mock -CommandName Get-ADOPSRepository -ModuleName ADOPS -MockWith {
                '{
                    "id": "33b33b3b-b33b-33bb-3bbb-33b3bbb33b33",
                    "name": "dummyName",
                    "url": "https://dev.azure.com/dummyOrg/2222cccc-22c2-2222-22cc-2222c22c222c/_apis/git/repositories/1a1aaaa1-aa1a-1a11-1111-11111aa11a1a",
                    "defaultBranch": "refs/heads/main"
                }' | ConvertFrom-Json   
            }
        }

        It 'If organization is given, it should not call GetADOPSDefaultOrganization' {
            $r = New-ADOPSGitFile -Organization 'DummyOrg' -Project 'DummyProj' -Repository 'DummyRepo' -File "$PSScriptRoot\New-ADOPSGitFile.Tests.yaml"
            Should -Invoke -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -Times 0 -Exactly
        }
        It 'If organization is not given, in should call GetADOPSDefaultOrganization' {
            $r = New-ADOPSGitFile -Project 'DummyProj' -Repository 'DummyRepo' -File "$PSScriptRoot\New-ADOPSGitFile.Tests.yaml"
            Should -Invoke -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -Times 1 -Exactly
        }

        It 'Gets the repo details using Get-ADOPSRepository' {
            $r = New-ADOPSGitFile -Project 'DummyProj' -Repository 'DummyRepo' -File "$PSScriptRoot\New-ADOPSGitFile.Tests.yaml"
            Should -Invoke -CommandName Get-ADOPSRepository -ModuleName ADOPS -Times 1 -Exactly
        }

        It 'Gets the latest refId usning InvokeADOPSRestMethod' {
            $r = New-ADOPSGitFile -Project 'DummyProj' -Repository 'DummyRepo' -File "$PSScriptRoot\New-ADOPSGitFile.Tests.yaml"
            Should -Invoke -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -Times 1 -ParameterFilter {
                $Uri -eq 'https://dev.azure.com/dummyOrg/2222cccc-22c2-2222-22cc-2222c22c222c/_apis/git/repositories/1a1aaaa1-aa1a-1a11-1111-11111aa11a1a/refs?filter=heads/main&includeStatuses=true&latestStatusesOnly=true&api-version=7.2-preview.2'
            }
        }

        It 'Verifying URI' {
            $required = 'https://dev.azure.com/dummyOrg/2222cccc-22c2-2222-22cc-2222c22c222c/_apis/git/repositories/1a1aaaa1-aa1a-1a11-1111-11111aa11a1a/pushes?api-version=7.2-preview.3'
            $actual = New-ADOPSGitFile -Project 'DummyProj' -Repository 'DummyRepo' -File "$PSScriptRoot\New-ADOPSGitFile.Tests.yaml"
            $actual.Uri | Should -Be $required
        }

        It 'Verifying Method' {
            $required = 'Post'
            $actual = New-ADOPSGitFile -Project 'DummyProj' -Repository 'DummyRepo' -File "$PSScriptRoot\New-ADOPSGitFile.Tests.yaml"
            $actual.Method | Should -Be $required
        }

        It 'Verifying Body - No values set' {
            $required = '{"refUpdates":[{"name":"refs/heads/main","oldObjectId":"dd4d4ddd-4d44-44dd-44d4-4dddd44d4444"}],"commits":[{"comment":"File added using the ADOPS PowerShell module","changes":[{"changeType":"add","item":{"path":"/New-ADOPSGitFile.Tests.yaml"},"newContent":{"content":"trigger: none\r\n\r\npool: dummyPool\r\n\r\nparameters:\r\n- name: Param1\r\n  displayName: First parameter\r\n  type: string\r\n  default: \"value1\"\r\n  values:\r\n  - \"value1\"\r\n  - \"value2\"\r\n\r\n- task: PowerShell@2\r\n  displayName: Run some code\r\n  inputs:\r\n    targetType: ''inline''\r\n    script: |\r\n      Write-Host ''Hello world!''\r\n      Write-Host ''$(Param1)''\r\n","contentType":"rawtext"}}]}]}'
            $actual = New-ADOPSGitFile -Project 'DummyProj' -Repository 'DummyRepo' -File "$PSScriptRoot\New-ADOPSGitFile.Tests.yaml"
            $actual.Body | Should -Be $required
        }

        It 'Verifying Body - Filename set' {
            $required = '{"refUpdates":[{"name":"refs/heads/main","oldObjectId":"dd4d4ddd-4d44-44dd-44d4-4dddd44d4444"}],"commits":[{"comment":"File added using the ADOPS PowerShell module","changes":[{"changeType":"add","item":{"path":"/newFile.txt"},"newContent":{"content":"trigger: none\r\n\r\npool: dummyPool\r\n\r\nparameters:\r\n- name: Param1\r\n  displayName: First parameter\r\n  type: string\r\n  default: \"value1\"\r\n  values:\r\n  - \"value1\"\r\n  - \"value2\"\r\n\r\n- task: PowerShell@2\r\n  displayName: Run some code\r\n  inputs:\r\n    targetType: ''inline''\r\n    script: |\r\n      Write-Host ''Hello world!''\r\n      Write-Host ''$(Param1)''\r\n","contentType":"rawtext"}}]}]}'
            $actual = New-ADOPSGitFile -Project 'DummyProj' -Repository 'DummyRepo' -File "$PSScriptRoot\New-ADOPSGitFile.Tests.yaml" -FileName 'newFile.txt'
            $actual.Body | Should -Be $required
        }

        It 'Verifying Body - Path set' {
            $required = '{"refUpdates":[{"name":"refs/heads/main","oldObjectId":"dd4d4ddd-4d44-44dd-44d4-4dddd44d4444"}],"commits":[{"comment":"File added using the ADOPS PowerShell module","changes":[{"changeType":"add","item":{"path":"/new/path/to/file/New-ADOPSGitFile.Tests.yaml"},"newContent":{"content":"trigger: none\r\n\r\npool: dummyPool\r\n\r\nparameters:\r\n- name: Param1\r\n  displayName: First parameter\r\n  type: string\r\n  default: \"value1\"\r\n  values:\r\n  - \"value1\"\r\n  - \"value2\"\r\n\r\n- task: PowerShell@2\r\n  displayName: Run some code\r\n  inputs:\r\n    targetType: ''inline''\r\n    script: |\r\n      Write-Host ''Hello world!''\r\n      Write-Host ''$(Param1)''\r\n","contentType":"rawtext"}}]}]}'
            $actual = New-ADOPSGitFile -Project 'DummyProj' -Repository 'DummyRepo' -File "$PSScriptRoot\New-ADOPSGitFile.Tests.yaml" -Path '/new/path/to/file/'
            $actual.Body | Should -Be $required
        }

        It 'Verifying Body - Path and FileName set' {
            $required = '{"refUpdates":[{"name":"refs/heads/main","oldObjectId":"dd4d4ddd-4d44-44dd-44d4-4dddd44d4444"}],"commits":[{"comment":"File added using the ADOPS PowerShell module","changes":[{"changeType":"add","item":{"path":"/new/path/to/file/newFile.txt"},"newContent":{"content":"trigger: none\r\n\r\npool: dummyPool\r\n\r\nparameters:\r\n- name: Param1\r\n  displayName: First parameter\r\n  type: string\r\n  default: \"value1\"\r\n  values:\r\n  - \"value1\"\r\n  - \"value2\"\r\n\r\n- task: PowerShell@2\r\n  displayName: Run some code\r\n  inputs:\r\n    targetType: ''inline''\r\n    script: |\r\n      Write-Host ''Hello world!''\r\n      Write-Host ''$(Param1)''\r\n","contentType":"rawtext"}}]}]}'
            $actual = New-ADOPSGitFile -Project 'DummyProj' -Repository 'DummyRepo' -File "$PSScriptRoot\New-ADOPSGitFile.Tests.yaml" -Path '/new/path/to/file/' -FileName 'newFile.txt'
            $actual.Body | Should -Be $required
        }

        It 'Verifying Body - CommitMessage set' {
            $required = '{"refUpdates":[{"name":"refs/heads/main","oldObjectId":"dd4d4ddd-4d44-44dd-44d4-4dddd44d4444"}],"commits":[{"comment":"New commit message","changes":[{"changeType":"add","item":{"path":"/New-ADOPSGitFile.Tests.yaml"},"newContent":{"content":"trigger: none\r\n\r\npool: dummyPool\r\n\r\nparameters:\r\n- name: Param1\r\n  displayName: First parameter\r\n  type: string\r\n  default: \"value1\"\r\n  values:\r\n  - \"value1\"\r\n  - \"value2\"\r\n\r\n- task: PowerShell@2\r\n  displayName: Run some code\r\n  inputs:\r\n    targetType: ''inline''\r\n    script: |\r\n      Write-Host ''Hello world!''\r\n      Write-Host ''$(Param1)''\r\n","contentType":"rawtext"}}]}]}'
            $actual = New-ADOPSGitFile -Project 'DummyProj' -Repository 'DummyRepo' -File "$PSScriptRoot\New-ADOPSGitFile.Tests.yaml" -CommitMessage 'New commit message'
            $actual.Body | Should -Be $required
        }
    }
}
