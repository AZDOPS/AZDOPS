param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

AfterAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
}

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

Describe 'New-ADOPSUserStory' {
    Context 'Creating new user story' {
        BeforeAll {
            Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'Organization' }

            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {}
        
            $TestRunSplat = @{
                Organization = 'DummyOrg' 
                ProjectName = 'DummyProj'
                Title = 'USTitle'
                Description = 'USDescription'
                Tags = 'USTags'
                Priority = 'USPrio'
            }
        }

        It 'Should not get organization from GetADOPSDefaultOrganization when organization parameter is used' {
            New-ADOPSUserStory -Organization 'Organization' -ProjectName 'DummyProj' -Title 'USTitle' -Description 'USDescription' -Tags 'USTags' -Priority 'USPrio'
            Should -Invoke GetADOPSDefaultOrganization -ModuleName ADOPS -Times 0 -Exactly
        }

        It 'Should get organization using GetADOPSDefaultOrganization when organization parameter is not used' {
            New-ADOPSUserStory -ProjectName 'DummyProj' -Title 'USTitle' -Description 'USDescription' -Tags 'USTags' -Priority 'USPrio'
            Should -Invoke GetADOPSDefaultOrganization -ModuleName ADOPS -Times 1 -Exactly
        }
        
        It 'Should have called mock InvokeADOPSRestMethod' {
            $TesRes = New-ADOPSUserStory @TestRunSplat
            Should -Invoke -CommandName 'InvokeADOPSRestMethod' -Exactly 1 -ModuleName ADOPS
        }
        
        It 'Verifying post object, ContentType' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $ContentType
            }

            $TesRes = New-ADOPSUserStory @TestRunSplat
            $TesRes | Should -Be "application/json-patch+json"
        }
        It 'Verifying post object, Body' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $Body
            }
            
            $DesiredReslt = '[{"op":"add","path":"/fields/System.Title","value":"USTitle"},{"op":"add","path":"/fields/System.Description","value":"USDescription"},{"op":"add","path":"/fields/System.Tags","value":"USTags"},{"op":"add","path":"/fields/Microsoft.VSTS.Common.Priority","value":"USPrio"}]'
            $TesRes = (New-ADOPSUserStory @TestRunSplat) | ConvertFrom-Json | ConvertTo-Json -Compress
            $TesRes | Should -Be $DesiredReslt
        }
    }
}