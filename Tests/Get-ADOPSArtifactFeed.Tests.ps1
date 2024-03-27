param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'Get-ADOPSArtifactFeed' {
    Context 'Parameters' {
        $TestCases = @(
            @{
                Name = 'Organization'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'Project'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'FeedId'
                Mandatory = $false
                Type = 'string'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command Get-ADOPSArtifactFeed | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }
    
    Context 'functionality' {
        BeforeAll {
            Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'DummyOrg' }

            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return '{"count": 1,"value": [{"name": "testFeed","fullyQualifiedName": "testFeed"}]}' | ConvertFrom-Json
            }
        }
        
        It 'Should not get organization from GetADOPSDefaultOrganization when organization parameter is used' {
            Get-ADOPSArtifactFeed -Organization 'anotherorg' -Project 'dummyProj'
            Should -Invoke GetADOPSDefaultOrganization -ModuleName ADOPS -Times 0 -Exactly
        }

        It 'Should get organization using GetADOPSDefaultOrganization when organization parameter is not used' {
            Get-ADOPSArtifactFeed -Project 'dummyProj'
            Should -Invoke GetADOPSDefaultOrganization -ModuleName ADOPS -Times 1 -Exactly
        }

        It 'Verifying URI, no project given' {
            InModuleScope -ModuleName ADOPS {
                Mock -CommandName Write-Output -ModuleName ADOPS -MockWith {
                    return $Uri
                }
            }
            $Expected = 'https://feeds.dev.azure.com/DummyOrg/_apis/packaging/feeds?api-version=7.2-preview.1'
            $Actual = Get-ADOPSArtifactFeed
            $Actual | Should -Be $Expected
        }

        It 'Verifying URI, no feed id given' {
            InModuleScope -ModuleName ADOPS {
                Mock -CommandName Write-Output -ModuleName ADOPS -MockWith {
                    return $Uri
                }
            }
            $Expected = 'https://feeds.dev.azure.com/DummyOrg/dummyProj/_apis/packaging/feeds?api-version=7.2-preview.1'
            $Actual = Get-ADOPSArtifactFeed -Project 'dummyProj'
            $Actual | Should -Be $Expected
        }

        It 'Verifying URI, feed id given' {
            InModuleScope -ModuleName ADOPS {
                Mock -CommandName Write-Output -ModuleName ADOPS -MockWith {
                    return $Uri
                }
            }
            $Expected = 'https://feeds.dev.azure.com/DummyOrg/dummyProj/_apis/packaging/feeds/feedIdGoesHere?api-version=7.2-preview.1'
            $Actual = Get-ADOPSArtifactFeed -Project 'dummyProj' -FeedId 'feedIdGoesHere'
            $Actual | Should -Be $Expected
        }

        It 'Verifying Method' {
            InModuleScope -ModuleName ADOPS {
                Mock -CommandName Write-Output -ModuleName ADOPS -MockWith {
                    return $Method
                }
            }
            $Expected = 'Get'
            $Actual = Get-ADOPSArtifactFeed -Project 'dummyProj'
            $Actual | Should -Be $Expected
        }

        It 'Should return the value if a list is returned' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return '{"count": 1,"value": [{"name": "testFeed","fullyQualifiedName": "testFeed"}]}' | ConvertFrom-Json
            }
            $Expected = 'testFeed'
            $Actual = Get-ADOPSArtifactFeed -Project 'dummyProj'
            $Actual.Name | Should -Be $Expected
            $Actual.Count | Should -Be 1
        }

        It 'Should return the value if a single object is returned' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return '{"name": "testFeed","fullyQualifiedName": "testFeed"}' | ConvertFrom-Json
            }
            $Expected = 'testFeed'
            $Actual = Get-ADOPSArtifactFeed -Project 'dummyProj'
            $Actual.Name | Should -Be $Expected
            $Actual.Count | Should -Be 1
        }
    }
}