#Requires -Module @{ ModuleName = 'Pester'; ModuleVersion = '5.3.1' }

Remove-Module AZDOPS -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot\..\Source\AZDOPS

InModuleScope -ModuleName AZDOPS {
    Describe 'New-AZDOPSUserStory tests' {

        Context 'Parameters' {
            It 'Should have parameter Organization' {
                (Get-Command New-AZDOPSUserStory).Parameters.Keys | Should -Contain 'Organization'
            }
            It 'Should have parameter ProjectName' {
                (Get-Command New-AZDOPSUserStory).Parameters.Keys | Should -Contain 'ProjectName'
            }
            It 'ProjectName should be required' {
                (Get-Command New-AZDOPSUserStory).Parameters['ProjectName'].Attributes.Mandatory | Should -Be $true
            }
            It 'Should have parameter Title' {
                (Get-Command New-AZDOPSUserStory).Parameters.Keys | Should -Contain 'Title'
            }
            It 'Title should be required' {
                (Get-Command New-AZDOPSUserStory).Parameters['Title'].Attributes.Mandatory | Should -Be $true
            }
            It 'Should have parameter Description' {
                (Get-Command New-AZDOPSUserStory).Parameters.Keys | Should -Contain 'Description'
            }
            It 'Description should not be required' {
                (Get-Command New-AZDOPSUserStory).Parameters['Description'].Attributes.Mandatory | Should -Be $false
            }
            It 'Should have parameter Tags' {
                (Get-Command New-AZDOPSUserStory).Parameters.Keys | Should -Contain 'Tags'
            }
            It 'Tags should not be required' {
                (Get-Command New-AZDOPSUserStory).Parameters['Tags'].Attributes.Mandatory | Should -Be $false
            }
            It 'Should have parameter Priority' {
                (Get-Command New-AZDOPSUserStory).Parameters.Keys | Should -Contain 'Priority'
            }
            It 'Priority should not be required' {
                (Get-Command New-AZDOPSUserStory).Parameters['Priority'].Attributes.Mandatory | Should -Be $false
            }
        }
    }
}

Describe 'New-AZDOPSUserStory' {
    Context 'Creating new user story' {
        BeforeAll {
            InModuleScope -ModuleName AZDOPS {
                Mock -CommandName GetAZDOPSHeader -ModuleName AZDOPS -MockWith {
                    @{
                        Header       = @{
                            'Authorization' = 'Basic Base64=='
                        }
                        Organization = $OrganizationName
                    }
                } -ParameterFilter { $OrganizationName -eq 'Organization' }
                Mock -CommandName GetAZDOPSHeader -ModuleName AZDOPS -MockWith {
                    @{
                        Header       = @{
                            'Authorization' = 'Basic Base64=='
                        }
                        Organization = 'DummyOrg'
                    }
                }

                Mock -CommandName InvokeAZDOPSRestMethod -MockWith {
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
        
        It 'Should have called mock InvokeAZDOPSRestMethod' {
            $TesRes = New-AZDOPSUserStory @TestRunSplat
            Should -Invoke -CommandName 'InvokeAZDOPSRestMethod' -Exactly 1 -ModuleName AZDOPS
        }
        It 'Should have called mock GetAZDOPSHeader' {
            $TesRes = New-AZDOPSUserStory @TestRunSplat
            Should -Invoke -CommandName 'GetAZDOPSHeader' -Exactly 1 -ModuleName AZDOPS
        }
        
        It 'Verifying post object, ContentType' {
            $TesRes = New-AZDOPSUserStory @TestRunSplat
            $TesRes.ContentType | Should -Be "application/json-patch+json"
        }
        It 'Verifying post object, Body' {
            $DesiredReslt = '[{"op":"add","path":"/fields/System.Title","value":"USTitle"},{"op":"add","path":"/fields/System.Description","value":"USDescription"},{"op":"add","path":"/fields/System.Tags","value":"USTags"},{"op":"add","path":"/fields/Microsoft.VSTS.Common.Priority","value":"USPrio"}]'
            $TesRes = (New-AZDOPSUserStory @TestRunSplat).Body | ConvertFrom-Json | ConvertTo-Json -Compress
            $TesRes | Should -Be $DesiredReslt
        }
    }
}