Remove-Module AZDevOPS -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot\..\Source\AZDevOPS

InModuleScope -ModuleName AZDevOPS {
    Describe 'New-AZDevOPSProject tests' {
        Context 'Creating project' {
            BeforeAll {
                Mock -CommandName GetAZDevOPSHeader -ModuleName AZDevOPS -MockWith {
                    @{
                        Header       = @{
                            'Authorization' = 'Basic Base64=='
                        }
                        Organization = $OrganizationName
                    }
                } -ParameterFilter { $OrganizationName -eq 'Organization' }
                Mock -CommandName GetAZDevOPSHeader -ModuleName AZDevOPS -MockWith {
                    @{
                        Header       = @{
                            'Authorization' = 'Basic Base64=='
                        }
                        Organization = $OrganizationName
                    }
                }

                Mock -CommandName InvokeAZDevOPSRestMethod -ModuleName AZDevOPS -MockWith {
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
                } -ParameterFilter { $method -eq 'Get' }
                Mock -CommandName InvokeAZDevOPSRestMethod -ModuleName AZDevOPS -MockWith {
                    return $InvokeSplat
                } -ParameterFilter { $method -eq 'Post' }

                $OrganizationName = 'DummyOrg'
                $ProjectName = 'DummyOrg'
            }

            It 'uses InvokeAZDevOPSRestMethod' {
                New-AZDevOPSProject -Organization $OrganizationName -Name $ProjectName -Visibility Private

                Should -Invoke 'InvokeAZDevOPSRestMethod' -ModuleName 'AZDevOPS' -Exactly -Times 2
            }
            It 'returns output after creating project' {
                New-AZDevOPSProject -Organization $OrganizationName -Name $ProjectName -Visibility 'Public' | Should -BeOfType [pscustomobject] -Because 'InvokeAZDevOPSRestMethod should convert the json to pscustomobject'
            }
            It 'should not throw with mandatory parameters' {
                { New-AZDevOPSProject -Organization $OrganizationName -Name $ProjectName -Visibility 'Public' } | Should -Not -Throw
            }
            It 'should throw with invalid Visibility parameter' {
                { New-AZDevOPSProject -Organization $OrganizationName -Name $ProjectName -Visibility 'DummyVisibility' } | Should -Throw
            }
            It 'should throw with invalid SourceControlType parameter' {
                { New-AZDevOPSProject -Organization $OrganizationName -Name $ProjectName -SourceControlType 'DummySourceControl' -Visibility 'Private' } | Should -Throw
            }
            It 'should throw with invalid ProcessTypeName parameter' {
                { New-AZDevOPSProject -Organization $OrganizationName -Name $ProjectName -ProcessTypeName "Dummy Process" -Visibility 'Private' } | Should -Throw
            }
            It 'should not throw with Basic ProcessTypeName parameter' {
                { New-AZDevOPSProject -Organization $OrganizationName -Name $ProjectName -ProcessTypeName "Basic" -Visibility 'Private' } | Should -Not -Throw
            }
        }

        Context 'Parameters' {
            It 'Should have parameter Organization' {
                (Get-Command New-AZDevOPSProject).Parameters.Keys | Should -Contain 'Organization'
            }
            It 'Organization should not be required' {
                (Get-Command New-AZDevOPSProject).Parameters['Organization'].Attributes.Mandatory | Should -Be $false
            }
            It 'Should have parameter Name' {
                (Get-Command New-AZDevOPSProject).Parameters.Keys | Should -Contain 'Name'
            }
            It 'Name should be required' {
                (Get-Command New-AZDevOPSProject).Parameters['Name'].Attributes.Mandatory | Should -Be $true
            }
            It 'Should have parameter Description' {
                (Get-Command New-AZDevOPSProject).Parameters.Keys | Should -Contain 'Description'
            }
            It 'Description should not be required' {
                (Get-Command New-AZDevOPSProject).Parameters['Description'].Attributes.Mandatory | Should -Be $false
            }
            It 'Should have parameter Visibility' {
                (Get-Command New-AZDevOPSProject).Parameters.Keys | Should -Contain 'Visibility'
            }
            It 'Visibility should be required' {
                (Get-Command New-AZDevOPSProject).Parameters['Visibility'].Attributes.Mandatory | Should -Be $true
            }
            It 'Should have parameter SourceControlType' {
                (Get-Command New-AZDevOPSProject).Parameters.Keys | Should -Contain 'SourceControlType'
            }
            It 'SourceControlType should be required' {
                (Get-Command New-AZDevOPSProject).Parameters['SourceControlType'].Attributes.Mandatory | Should -Be $false
            }
            It 'Should have parameter ProcessTypeName' {
                (Get-Command New-AZDevOPSProject).Parameters.Keys | Should -Contain 'ProcessTypeName'
            }
            It 'ProcessTypeName should be required' {
                (Get-Command New-AZDevOPSProject).Parameters['ProcessTypeName'].Attributes.Mandatory | Should -Be $false
            }
        }
    }
}