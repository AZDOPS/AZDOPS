param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'Set-ADOPSBuildDefinition' {
    Context 'Parameters' {
        $TestCases = @(
            @{
                Name = 'Organization'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'DefinitionObject'
                Mandatory = $true
                Type = 'Object'
            }
        )

        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command Set-ADOPSBuildDefinition | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }
    
    Context 'Setting build definition' {
        BeforeAll {
            $OrganizationName = 'DummyOrg'
            $definitionObject = @{
                id = 1
                project = @{
                    id = '00a00a0a-0000-0aaa-aa00-a0a000000aa0'
                }
            }

            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $InvokeSplat
            }

            Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'DummyOrg' }
        }
        
        It 'If no org is given, calls GetADOPSDefaultOrganization once' {
            Set-ADOPSBuildDefinition -DefinitionObject $definitionObject
            Should -Invoke 'GetADOPSDefaultOrganization' -ModuleName 'ADOPS' -Exactly -Times 1
        }

        It 'URI should be correct' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $Uri
            }
            $actual = Set-ADOPSBuildDefinition -DefinitionObject $definitionObject
            $actual | Should -Be 'https://dev.azure.com/DummyOrg/00a00a0a-0000-0aaa-aa00-a0a000000aa0/_apis/build/definitions/1?api-version=7.2-preview.7'
        }

        It 'Method should be PUT' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $Method
            }
            $actual = Set-ADOPSBuildDefinition -DefinitionObject $definitionObject
            $actual | Should -Be 'Put'
        }

        It 'If body is JSON post if as is.' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $Body
            }
            $definitionObject = '[{"id":1,"name":"definition1"},{"id":2,"name":"definition2"}]'
            $actual = Set-ADOPSBuildDefinition -DefinitionObject $definitionObject
            $actual | Should -Be $definitionObject
        }

        It 'If body is array, convert to json.' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $Body
            }
            $definitionObject = '[{"id":1,"name":"definition1"},{"id":2,"name":"definition2"}]' | ConvertFrom-Json
            $resultObject = '[{"id":1,"name":"definition1"},{"id":2,"name":"definition2"}]'
            $actual = Set-ADOPSBuildDefinition -DefinitionObject $definitionObject
            $actual | Should -Be $resultObject
        }
    }
}
