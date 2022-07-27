Remove-Module ADOPS -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot\..\Source\ADOPS

InModuleScope -ModuleName ADOPS {
    Describe 'New-ADOPSUserStory tests' {

        Context 'Parameters' {
            It 'Should have parameter Organization' {
                (Get-Command New-ADOPSUserStory).Parameters.Keys | Should -Contain 'Organization'
            }
            It 'Should have parameter ProjectName' {
                (Get-Command New-ADOPSUserStory).Parameters.Keys | Should -Contain 'ProjectName'
            }
            It 'ProjectName should be required' {
                (Get-Command New-ADOPSUserStory).Parameters['ProjectName'].Attributes.Mandatory | Should -Be $true
            }
            It 'Should have parameter Title' {
                (Get-Command New-ADOPSUserStory).Parameters.Keys | Should -Contain 'Title'
            }
            It 'Title should be required' {
                (Get-Command New-ADOPSUserStory).Parameters['Title'].Attributes.Mandatory | Should -Be $true
            }
            It 'Should have parameter Description' {
                (Get-Command New-ADOPSUserStory).Parameters.Keys | Should -Contain 'Description'
            }
            It 'Description should not be required' {
                (Get-Command New-ADOPSUserStory).Parameters['Description'].Attributes.Mandatory | Should -Be $false
            }
            It 'Should have parameter Tags' {
                (Get-Command New-ADOPSUserStory).Parameters.Keys | Should -Contain 'Tags'
            }
            It 'Tags should not be required' {
                (Get-Command New-ADOPSUserStory).Parameters['Tags'].Attributes.Mandatory | Should -Be $false
            }
            It 'Should have parameter Priority' {
                (Get-Command New-ADOPSUserStory).Parameters.Keys | Should -Contain 'Priority'
            }
            It 'Priority should not be required' {
                (Get-Command New-ADOPSUserStory).Parameters['Priority'].Attributes.Mandatory | Should -Be $false
            }
        }
    }
}

Describe 'New-ADOPSUserStory' {
    Context 'Creating new user story' {
        BeforeAll {
            InModuleScope -ModuleName ADOPS {
                Mock -CommandName GetADOPSHeader -ModuleName ADOPS -MockWith {
                    @{
                        Header       = @{
                            'Authorization' = 'Basic Base64=='
                        }
                        Organization = $OrganizationName
                    }
                } -ParameterFilter { $OrganizationName -eq 'Organization' }
                Mock -CommandName GetADOPSHeader -ModuleName ADOPS -MockWith {
                    @{
                        Header       = @{
                            'Authorization' = 'Basic Base64=='
                        }
                        Organization = 'DummyOrg'
                    }
                }

                Mock -CommandName InvokeADOPSRestMethod -MockWith {
                    return $InvokeSplat
                }
            }

            $TestRunSplat = @{
                Organization = 'DummyOrg'
                ProjectName = 'DummyProj'
                Title = 'USTitle'
                Description = 'USDescription'
                Tags = 'USTags'
                Priority = 'USPrio'
            }
        }

        It 'Should have called mock InvokeADOPSRestMethod' {
            $TesRes = New-ADOPSUserStory @TestRunSplat
            Should -Invoke -CommandName 'InvokeADOPSRestMethod' -Exactly 1 -ModuleName ADOPS
        }
        It 'Should have called mock GetADOPSHeader' {
            $TesRes = New-ADOPSUserStory @TestRunSplat
            Should -Invoke -CommandName 'GetADOPSHeader' -Exactly 1 -ModuleName ADOPS
        }

        It 'Verifying post object, ContentType' {
            $TesRes = New-ADOPSUserStory @TestRunSplat
            $TesRes.ContentType | Should -Be "application/json-patch+json"
        }
        It 'Verifying post object, Body' {
            $DesiredReslt = '[{"op":"add","path":"/fields/System.Title","value":"USTitle"},{"op":"add","path":"/fields/System.Description","value":"USDescription"},{"op":"add","path":"/fields/System.Tags","value":"USTags"},{"op":"add","path":"/fields/Microsoft.VSTS.Common.Priority","value":"USPrio"}]'
            $TesRes = (New-ADOPSUserStory @TestRunSplat).Body | ConvertFrom-Json | ConvertTo-Json -Compress
            $TesRes | Should -Be $DesiredReslt
        }
    }
}