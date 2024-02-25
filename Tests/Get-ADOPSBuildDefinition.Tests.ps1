param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'Get-ADOPSBuildDefinition' {
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
                Name = 'Id'
                Mandatory = $false
                Type = 'int'
            }
        )

        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command Get-ADOPSBuildDefinition | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }
    
    Context 'Getting Build definition' {
        BeforeAll {
            $OrganizationName = 'DummyOrg'
            $Project = 'DummyProject'

            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return @'
                {
                    "count": 2,
                    "value": [
                      {
                        "id": 1,
                        "name": "definition1"
                      },
                      {
                        "id": 2,
                        "name": "definition2"
                      },
                      {
                        "id": 3,
                        "name": "definition3"
                      }
                    ]
                  }                  
'@ | ConvertFrom-Json
            } -ParameterFilter { $Method -eq 'Get' -and $Uri -like '*/definitions?*' }

            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return @'
                {
                    "id": 3,
                    "name": "definition3-specific"
                }                  
'@ | ConvertFrom-Json
            } -ParameterFilter { $Method -eq 'Get' -and $Uri -like '*/definitions/*' }

            Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'DummyOrg' }
        }
        
        It 'If no org is given, calls GetADOPSDefaultOrganization once' {
            Get-ADOPSBuildDefinition -Project $Project
            Should -Invoke 'GetADOPSDefaultOrganization' -ModuleName 'ADOPS' -Exactly -Times 1
        }

        It 'If no Id is given, retrun all objects' {
            $actual = Get-ADOPSBuildDefinition -Project $Project
            $actual.count | Should -Be 3
        }

        It 'If an Id is given, Only one object should be returned, type should be array' {
            $actual = Get-ADOPSBuildDefinition -Project $Project
            $actual.GetType().BaseType.Name | Should -Be 'Array'
        }

        It 'If an Id is given, Only that id should be returned' {
            $actual = Get-ADOPSBuildDefinition -Project $Project -Id 3
            $actual.count | Should -Be 1
        }

        It 'If an Id is given, Only one object should be returned, type should be array' {
            $actual = Get-ADOPSBuildDefinition -Project $Project -Id 3
            $actual.GetType().BaseType.Name | Should -Be 'Array'
        }
    }
}
