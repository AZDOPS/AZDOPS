param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe "Get-ADOPSFileContent" {
    Context "Parameters" {
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
                Name = 'FilePath'
                Mandatory = $true
                Type = 'string'
            }
        )

        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command Get-ADOPSFileContent | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }

    Context "Functionality" {
        BeforeAll {
            Mock InvokeADOPSRestMethod -ModuleName ADOPS { }

            Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'DummyOrg' }
        }

        it 'Should not get organization from GetADOPSDefaultOrganization when organization parameter is used' {
            Get-ADOPSFileContent -Organization 'Organization' -Project 'MyProj' -RepositoryId 'abc123' -FilePath '/noFile.yaml'
            Should -Invoke GetADOPSDefaultOrganization -ModuleName ADOPS -Times 0 -Exactly
        }

        it 'Should get organization using GetADOPSDefaultOrganization when organization parameter is not used' {
            Get-ADOPSFileContent -Project 'MyProj' -RepositoryId 'abc123' -FilePath '/noFile.yaml'
            Should -Invoke GetADOPSDefaultOrganization -ModuleName ADOPS -Times 1 -Exactly
        }

        it 'If file path does not start with a /, prepend it' {
            Mock InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $Uri
            }

            Get-ADOPSFileContent -Project 'MyProj' -RepositoryId 'abc123' -FilePath 'path/noFile.yaml' | Should -Be 'https://dev.azure.com/DummyOrg/MyProj/_apis/git/repositories/abc123/items?path=%2fpath%2fnoFile.yaml&api-version=7.1-preview.1'
        }

        it 'Url should be correctly structured' {
            Mock InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $Uri
            }

            Get-ADOPSFileContent -Project 'MyProj' -RepositoryId 'abc123' -FilePath '/path/noFile.yaml' | Should -Be 'https://dev.azure.com/DummyOrg/MyProj/_apis/git/repositories/abc123/items?path=%2fpath%2fnoFile.yaml&api-version=7.1-preview.1'
        }
    }
}