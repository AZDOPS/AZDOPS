Remove-Module ADOPS -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot\..\Source\ADOPS

InModuleScope -ModuleName ADOPS {
    Describe 'New-ADOPSUserStory' {
        Context 'Parameters' {
            $TestCases = @(
                @{
                    Name = 'Organization'
                    Mandatory = $false
                    Type = 'string'
                },
                @{
                    Name = 'ProjectName'
                    Mandatory = $true
                    Type = 'string'
                },
                @{
                    Name = 'Title'
                    Mandatory = $true
                    Type = 'string'
                },
                @{
                    Name = 'Description'
                    Mandatory = $false
                    Type = 'string'
                },
                @{
                    Name = 'Tags'
                    Mandatory = $false
                    Type = 'string'
                },
                @{
                    Name = 'Priority'
                    Mandatory = $false
                    Type = 'string'
                }
            )
        
            It 'Should have parameter <_.Name>' -TestCases $TestCases  {
                Get-Command New-ADOPSUserStory | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
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