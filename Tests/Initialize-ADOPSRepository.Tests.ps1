param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'Initialize-ADOPSRepository' {
    Context 'Parameters' {
        BeforeAll {
            $r  = Get-Command -Name Initialize-ADOPSRepository -Module ADOPS
        }

        $TestCases = @(
            @{
                Name = 'Message'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'Branch'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'RepositoryId'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'newContentTemplate'
                Mandatory = $false
                Type = 'string[]'
            },
            @{
                Name = 'Readme'
                Mandatory = $false
                Type = 'switch'
            },
            @{
                Name = 'Path'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'Content'
                Mandatory = $false
                Type = 'string'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command Initialize-ADOPSRepository | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }

    Context 'Running command' {
        BeforeAll {
            $RepositoryId = 'd8109801-bf95-4c42-813d-cda3e506b469'

            InModuleScope -ModuleName ADOPS {
                Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'DummyOrg' }
                
                Mock -CommandName InvokeADOPSRestMethod  -ModuleName ADOPS -MockWith {
                    return $InvokeSplat
                }
            }
        }

        It 'Should always call GetADOPSDefaultOrganization as it can only initialize repos using current connection' {
            $r = Initialize-ADOPSRepository -RepositoryId $RepositoryId
            Should -Invoke -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -Times 1 -Exactly
        }

        It 'Post content should be correct - URI' {
            $required = "https://dev.azure.com/DummyOrg/_apis/git/repositories/$RepositoryId/pushes?api-version=7.2-preview.3"
            $actual = Initialize-ADOPSRepository -RepositoryId $RepositoryId
            $actual.Uri | Should -Be $required
        }

        It 'Post content should be correct - Method' {
            $required = 'Post'
            $actual = Initialize-ADOPSRepository -RepositoryId $RepositoryId
            $actual.Method | Should -Be $required
        }

        It 'Post content should be correct - Body - Branch should default to refs/head/main' {
            $required = 'refs/heads/main'
            $Res = Initialize-ADOPSRepository -RepositoryId $RepositoryId
            $actual = ($Res.Body | ConvertFrom-Json).refUpdates[0].name
            $actual | Should -Be $required
        }

        It 'Post content should be correct - Body - Branch should be set if given, only branch name' {
            $required = 'refs/heads/branch'
            $Res = Initialize-ADOPSRepository -RepositoryId $RepositoryId -Branch 'branch'
            $actual = ($Res.Body | ConvertFrom-Json).refUpdates[0].name
            $actual | Should -Be $required
        }

        It 'Post content should be correct - Body - Branch should be set if given, full branch path' {
            $required = 'refs/my/branch/path'
            $Res = Initialize-ADOPSRepository -RepositoryId $RepositoryId -Branch 'refs/my/branch/path'
            $actual = ($Res.Body | ConvertFrom-Json).refUpdates[0].name
            $actual | Should -Be $required
        }

        It 'Post content should be correct - Body - Default commit message should be set' {
            $required = 'Repo initialized using ADOPS module.'
            $Res = Initialize-ADOPSRepository -RepositoryId $RepositoryId
            $actual = ($Res.Body | ConvertFrom-Json).commits.comment
            $actual | Should -Be $required
        }

        It 'Post content should be correct - Body - Custom commit message should be set' {
            $required = 'Custom commit message'
            $Res = Initialize-ADOPSRepository -RepositoryId $RepositoryId -Message 'Custom commit message'
            $actual = ($Res.Body | ConvertFrom-Json).commits.comment
            $actual | Should -Be $required
        }

        It 'Body - Changes - If no parameter is given, default should be standard readme template' {
            $Res = Initialize-ADOPSRepository -RepositoryId $RepositoryId
            $actual = ($Res.Body | ConvertFrom-Json).commits.changes
            $actual.Count | Should -Be 1
            $actual[0].newContentTemplate.name | Should -Be 'README.md'
        }

        It 'Body - Changes - If no parameter is given, default should be standard readme template' {
            $Res = Initialize-ADOPSRepository -RepositoryId $RepositoryId
            $actual = ($Res.Body | ConvertFrom-Json).commits.changes
            $actual[0].newContentTemplate.type | Should -Be 'readme'
        }

        It 'Body - Changes - If no parameter is given, default should be standard readme template' {
            $Res = Initialize-ADOPSRepository -RepositoryId $RepositoryId
            $actual = ($Res.Body | ConvertFrom-Json).commits.changes
            $actual[0].item.path | Should -Be '/README.md'
        }

        It 'Body - Changes - If Readme parameter is given, standard readme template should be used' {
            $Res = Initialize-ADOPSRepository -RepositoryId $RepositoryId -Readme
            $actual = ($Res.Body | ConvertFrom-Json).commits.changes
            $actual.Count | Should -Be 1
            $actual[0].newContentTemplate.type | Should -Be 'readme'
        }

        It 'Body - Changes - If a path is given, set the path and content.' {
            $Res = Initialize-ADOPSRepository -RepositoryId $RepositoryId -Path '/customContent.txt' -Content 'Custom content'
            $actual = ($Res.Body | ConvertFrom-Json).commits.changes[0].newContent.content
            $actual | Should -Be 'Custom content'
        }

        It 'Body - Changes - If a path is given, set the path and content.' {
            $Res = Initialize-ADOPSRepository -RepositoryId $RepositoryId -Path '/customContent.txt' -Content 'Custom content'
            $actual = ($Res.Body | ConvertFrom-Json).commits.changes[0].item.path
            $actual | Should -Be '/customContent.txt'
        }

        It 'Body - Changes - If one template is given, set it as .gitignore' {
            $Res = Initialize-ADOPSRepository -RepositoryId $RepositoryId -newContentTemplate Actionscript.gitignore
            $actual = ($Res.Body | ConvertFrom-Json).commits.changes
            $actual[0].newContentTemplate.type | Should -Be 'gitignore'
        }

        It 'Body - Changes - If one template is given, set it as .gitignore' {
            $Res = Initialize-ADOPSRepository -RepositoryId $RepositoryId -newContentTemplate Actionscript.gitignore
            $actual = ($Res.Body | ConvertFrom-Json).commits.changes
            $actual[0].newContentTemplate.name | Should -Be 'Actionscript.gitignore'
        }

        It 'Body - Changes - If one template is given, set it as .gitignore' {
            $Res = Initialize-ADOPSRepository -RepositoryId $RepositoryId -newContentTemplate Actionscript.gitignore
            $actual = ($Res.Body | ConvertFrom-Json).commits.changes
            $actual[0].item.path| Should -Be '/.gitignore'
        }

        It 'Body - Changes - If more than one template is given, add it as templatename, count.' {
            $Res = Initialize-ADOPSRepository -RepositoryId $RepositoryId -newContentTemplate Actionscript.gitignore, Ada.gitignore, Agda.gitignore
            $actual = ($Res.Body | ConvertFrom-Json).commits.changes
            $actual.Count | Should -Be 3
        }

        It 'Body - Changes - If more than one template is given, add it as templatename, type, <_>' -TestCases @('Actionscript.gitignore', 'Ada.gitignore', 'Agda.gitignore') {
            $multiTemplateTestcases = @('Actionscript.gitignore', 'Ada.gitignore', 'Agda.gitignore')
            $currName = $_
            $Res = Initialize-ADOPSRepository -RepositoryId $RepositoryId -newContentTemplate $multiTemplateTestcases
            $actual = ($Res.Body | ConvertFrom-Json).commits.changes.where({$_.newContentTemplate.name -eq $currName})
            $actual.newContentTemplate.type | Should -Be 'gitignore'
        }

        It 'Body - Changes - If more than one template is given, add it as templatename, name, <_>' -TestCases @('Actionscript.gitignore', 'Ada.gitignore', 'Agda.gitignore') {
            $multiTemplateTestcases = @('Actionscript.gitignore', 'Ada.gitignore', 'Agda.gitignore')
            $currName = $_
            $Res = Initialize-ADOPSRepository -RepositoryId $RepositoryId -newContentTemplate $multiTemplateTestcases
            $actual = ($Res.Body | ConvertFrom-Json).commits.changes.where({$_.newContentTemplate.name -eq $currName})
            $actual.newContentTemplate.name | Should -Be $currName
        }

        It 'Body - Changes - If more than one template is given, add it as templatename, path, <_>' -TestCases @('Actionscript.gitignore', 'Ada.gitignore', 'Agda.gitignore') {
            $multiTemplateTestcases = @('Actionscript.gitignore', 'Ada.gitignore', 'Agda.gitignore')
            $currName = $_
            $Res = Initialize-ADOPSRepository -RepositoryId $RepositoryId -newContentTemplate $multiTemplateTestcases
            $actual = ($Res.Body | ConvertFrom-Json).commits.changes.where({$_.newContentTemplate.name -eq $currName})
            # Because .item is a static object member we need to index this as an array to get the actual member..
            $actual[0].item.path| Should -Be "/$_"
        }

        It 'Body - Changes - Combining templates and files should work, count.' {
            $Res = Initialize-ADOPSRepository -RepositoryId $RepositoryId -newContentTemplate Actionscript.gitignore, Android.gitignore -Readme -Path /fileName.txt 
            $actual = ($Res.Body | ConvertFrom-Json).commits.changes
            $actual.Count | Should -Be 4
        }
    }
}