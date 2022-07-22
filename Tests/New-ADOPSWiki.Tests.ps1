Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot\..\Source\ADOPS -Force

Describe "New-ADOPSWiki" {
    BeforeAll {
        Mock GetADOPSHeader -ModuleName ADOPS -MockWith {
            @{
                Organization = "myorg"
            }
        }
        Mock GetADOPSHeader -ModuleName ADOPS -ParameterFilter { $Organization -eq 'anotherorg' } -MockWith {
            @{
                Organization = "anotherOrg"
            }
        }
        Mock Get-ADOPSProject -ModuleName ADOPS -MockWith {
            @{
                id = "de6a3035-0146-4ae2-81c1-68596d187cf4"
            }
        }
        Mock Get-ADOPSRepository -ModuleName ADOPS -MockWith {
            @{
                id = "de6a3035-0146-4ae2-81c1-68596d187cf4"
            }
        }

        Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {}
    }

    Context "General function tests" {
        It "Function exist" {
            { Get-Command -Name New-ADOPSWiki -Module ADOPS -ErrorAction Stop } | Should -Not -Throw
        }

        It "Contains mandatory parameter: <_>" -TestCases 'Project', 'WikiName', 'WikiRepository' {
            Get-Command -Name New-ADOPSWiki | Should -HaveParameter $_ -Mandatory
        }

        It "Contains non mandatory parameter: <_>" -TestCases 'Organization', 'WikiRepositoryPath', 'GitBranch' {
            Get-Command -Name New-ADOPSWiki | Should -HaveParameter $_
        }
    }

    Context "Functionality" {
        It 'Should get organization from GetADOPSHeader when organization parameter is used' {
            New-ADOPSWiki -Organization 'anotherorg' -Project 'myproject' -WikiName 'MyWikiName' -WikiRepository 'MyWikiRepo'
            Should -Invoke GetADOPSHeader -ModuleName ADOPS -ParameterFilter { $Organization -eq 'anotherorg' } -Times 1 -Exactly
        }

        It 'Should validate organization using GetADOPSHeader when organization parameter is not used' {
            New-ADOPSWiki -Project 'myproject' -WikiName 'MyWikiName' -WikiRepository 'MyWikiRepo'
            Should -Invoke GetADOPSHeader -ModuleName ADOPS -ParameterFilter { $Organization -eq 'anotherorg' } -Times 0 -Exactly
            Should -Invoke GetADOPSHeader -ModuleName ADOPS -Times 1 -Exactly
        }

        It 'Should call Get-ADOPSProject once to get Project id' {
            New-ADOPSWiki -Project 'myproject' -WikiName 'MyWikiName' -WikiRepository 'MyWikiRepo'
            Should -Invoke Get-ADOPSProject -ModuleName ADOPS -Times 1 -Exactly
        }
        
        It 'Should call Get-ADOPSRepository once to get Repository id' {
            New-ADOPSWiki -Project 'myproject' -WikiName 'MyWikiName' -WikiRepository 'MyWikiRepo'
            Should -Invoke Get-ADOPSRepository -ModuleName ADOPS -Times 1 -Exactly
        }

        It 'Should call InvokeADOPSRestMethod once' {
            New-ADOPSWiki -Project 'myproject' -WikiName 'MyWikiName' -WikiRepository 'MyWikiRepo'
            Should -Invoke InvokeADOPSRestMethod -ModuleName ADOPS -Times 1 -Exactly
        }

        It 'Verifying URI' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $URI
            }

            $r = New-ADOPSWiki -Project 'myproject' -WikiName 'MyWikiName' -WikiRepository 'MyWikiRepo'
            $r | Should -Be 'https://dev.azure.com/myorg/_apis/wiki/wikis?api-version=7.1-preview.2'
        }

        It 'Verifying method' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $Method
            }
            $r = New-ADOPSWiki -Project 'myproject' -WikiName 'MyWikiName' -WikiRepository 'MyWikiRepo'
            $r | Should -Be 'Post'
        }

        It 'Verifying Body' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $Body
            }
            $Project = 'MyProject'
            $WikiName = 'MyWikiName'
            $WikiRepository = 'MyWikiRepo'
            $WikiRepositoryPath = '/path'
            $GitBranch = 'wikiBranch'

            $Body = "{""type"":""codeWiki"",""name"":""$WikiName"",""projectId"":""de6a3035-0146-4ae2-81c1-68596d187cf4"",""repositoryId"":""de6a3035-0146-4ae2-81c1-68596d187cf4"",""mappedPath"":""$WikiRepositoryPath"",""version"":{""version"":""$GitBranch""}}"
            $r = New-ADOPSWiki -Project $Project -WikiName $WikiName -WikiRepository $WikiRepository -WikiRepositoryPath $WikiRepositoryPath -GitBranch $GitBranch
            $r | Should -Be $Body
        }
    }
}