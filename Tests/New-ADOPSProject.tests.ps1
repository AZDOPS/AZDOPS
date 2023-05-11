param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'New-ADOPSProject' {
    Context 'Parameters' {
        $TestCases = @(
            @{
                Name = 'Organization'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'Name'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'Description'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'Visibility'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'SourceControlType'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'ProcessTypeName'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'Wait'
                Mandatory = $false
                Type = 'switch'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command New-ADOPSProject | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }

    Context 'Creating project' {
        BeforeAll {
            Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'myorg' }

            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return @"
                {
                    "count": 4,
                    "value": [
                        {
                        "id": "e5317e66-94c8-48cb-bed8-3f44ebdb0963",
                        "description": "This template is flexible for any process and great for teams getting started with Azure DevOps.",
                        "isDefault": true,
                        "type": "system",
                        "url": "https://dev.azure.com/$OrganizationName/_apis/process/processes/e5317e66-94c8-48cb-bed8-3f44ebdb0963",
                        "name": "Basic"
                        },
                        {
                        "id": "e5317e66-94c8-48cb-bed8-3f44ebdb0964",
                        "description": "This template is for teams who follow the Scrum framework.",
                        "isDefault": false,
                        "type": "system",
                        "url": "https://dev.azure.com/$OrganizationName/_apis/process/processes/e5317e66-94c8-48cb-bed8-3f44ebdb0964",
                        "name": "Scrum"
                        },
                        {
                        "id": "e5317e66-94c8-48cb-bed8-3f44ebdb0965",
                        "description": "This template is flexible and will work great for most teams using Agile planning methods, including those practicing Scrum.",
                        "isDefault": false,
                        "type": "system",
                        "url": "https://dev.azure.com/$OrganizationName/_apis/process/processes/e5317e66-94c8-48cb-bed8-3f44ebdb0965",
                        "name": "Agile"
                        },
                        {
                        "id": "e5317e66-94c8-48cb-bed8-3f44ebdb0966",
                        "description": "This template is for more formal projects requiring a framework for process improvement and an auditable record of decisions.",
                        "isDefault": false,
                        "type": "system",
                        "url": "https://dev.azure.com/$OrganizationName/_apis/process/processes/e5317e66-94c8-48cb-bed8-3f44ebdb0966",
                        "name": "CMMI"
                        }
                    ]
                    }
"@ | ConvertFrom-Json
            } -ParameterFilter { $Method -eq 'Get' }
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $InvokeSplat
            } -ParameterFilter { $Method -eq 'Post' }

            $OrganizationName = 'DummyOrg'
            $Project = 'DummyOrg'
        }

        It 'uses InvokeADOPSRestMethod two times' {
            New-ADOPSProject -Organization $OrganizationName -Name $Project -Visibility Private

            Should -Invoke 'InvokeADOPSRestMethod' -ModuleName 'ADOPS' -Exactly -Times 2
        }
        
        It 'should not throw with mandatory parameters' {
            { New-ADOPSProject -Name $Project -Visibility 'Public' } | Should -Not -Throw
        }
        
        It 'should throw with invalid Visibility parameter' {
            { New-ADOPSProject -Organization $OrganizationName -Name $Project -Visibility 'DummyVisibility' } | Should -Throw
        }
        
        It 'should throw with invalid SourceControlType parameter' {
            { New-ADOPSProject -Organization $OrganizationName -Name $Project -SourceControlType 'DummySourceControl' -Visibility 'Private' } | Should -Throw
        }
        
        It 'should throw with invalid ProcessTypeName parameter' {
            { New-ADOPSProject -Organization $OrganizationName -Name $Project -ProcessTypeName "Dummy Process" -Visibility 'Private' } | Should -Throw
        }
        
        It 'should not throw with Basic ProcessTypeName parameter' {
            { New-ADOPSProject -Organization $OrganizationName -Name $Project -ProcessTypeName "Basic" -Visibility 'Private' } | Should -Not -Throw
        }
        
        It 'Verify body' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $body
            } -ParameterFilter { $Method -eq 'Post' }

            $r = New-ADOPSProject -Organization $OrganizationName -Name $Project -Visibility 'Public' -Description 'DummyDescription'
            $r | Should -Be '{"name":"DummyOrg","visibility":"Public","capabilities":{"versioncontrol":{"sourceControlType":"Git"},"processTemplate":{"templateTypeId":"e5317e66-94c8-48cb-bed8-3f44ebdb0963"}},"description":"DummyDescription"}'
        }
                
        It 'Verify uri' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $uri
            } -ParameterFilter { $Method -eq 'Post' }

            $r = New-ADOPSProject -Organization $OrganizationName -Name $Project -Visibility 'Public' -Description 'DummyDescription'
            $r.OriginalString | Should -Be 'https://dev.azure.com/DummyOrg/_apis/projects?api-version=7.1-preview.4'
        }

        It 'if wait is defined, waits until status is "succeeded"' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                @{
                    id = "066488b8-b14e-43d1-befc-a2e655266e2b"
                    status = "queued"
                    url = "https://dev.azure.com/fabrikam/_apis/operations/066488b8-b14e-43d1-befc-a2e655266e2b"
                }
            } -ParameterFilter { $Method -eq 'Post' }

            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                @{
                    id = "066488b8-b14e-43d1-befc-a2e655266e2b"
                    status = "succeeded"
                    url = "https://dev.azure.com/fabrikam/_apis/operations/066488b8-b14e-43d1-befc-a2e655266e2b"
                }
            } -ParameterFilter { $Method -eq 'Get' -and $Uri -eq 'https://dev.azure.com/fabrikam/_apis/operations/066488b8-b14e-43d1-befc-a2e655266e2b'}

            Mock -CommandName Get-ADOPSProject -ModuleName ADOPS -MockWith {
                @{
                    id = "00000000-0000-0000-0000-000000000000"
                    name = "MyProj"
                    url = "https://dev.azure.com/MyProj/_apis/projects/00000000-0000-0000-0000-000000000000"
                    state = "wellFormed"
                    revision = 1
                    visibility = "private"
                    lastUpdateTime = "1901-01-01T00:00:00.0000000Z"
                  }
            }

            Mock -CommandName Start-Sleep -ModuleName ADOPS -MockWith {}

            $r = New-ADOPSProject -Organization $OrganizationName -Name $Project -Visibility 'Public' -Description 'DummyDescription' -Wait
            $r.name | Should -Be 'MyProj'
        }
    }

}
