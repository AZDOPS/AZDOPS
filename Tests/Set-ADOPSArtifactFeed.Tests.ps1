param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'Set-ADOPSArtifactFeed' {
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
                Name = 'FeedId'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'Description'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'UpstreamEnabled'
                Mandatory = $false
                Type = 'bool'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command Set-ADOPSArtifactFeed | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }
    
    Context 'functionality' {
        BeforeAll {
            Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'DummyOrg' }

            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith { }
        }
        
        It 'Should not get organization from GetADOPSDefaultOrganization when organization parameter is used' {
            Set-ADOPSArtifactFeed -Organization 'anotherorg' -Project 'dummyProj' -FeedId 'FeedIdGoesHere' -UpstreamEnabled:$true
            Should -Invoke GetADOPSDefaultOrganization -ModuleName ADOPS -Times 0 -Exactly
        }

        It 'Should get organization using GetADOPSDefaultOrganization when organization parameter is not used' {
            Set-ADOPSArtifactFeed -Project 'dummyProj' -FeedId 'FeedIdGoesHere' -UpstreamEnabled:$true
            Should -Invoke GetADOPSDefaultOrganization -ModuleName ADOPS -Times 1 -Exactly
        }

        It 'Verifying URI' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith { 
                return $Uri
            }
            
            $Expected = 'https://feeds.dev.azure.com/DummyOrg/dummyProj/_apis/packaging/feeds/FeedIdGoesHere?api-version=7.2-preview.1'
            $Actual = Set-ADOPSArtifactFeed -Project 'dummyProj' -FeedId 'FeedIdGoesHere' -UpstreamEnabled:$true
            $Actual | Should -Be $Expected
        }

        It 'Verifying Method' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith { 
                return $Method
            }
            $Expected = 'Patch'
            $Actual = Set-ADOPSArtifactFeed -Project 'dummyProj' -FeedId 'FeedIdGoesHere' -UpstreamEnabled:$true
            $Actual | Should -Be $Expected
        }
        
        It 'Verifying body, Description' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith { 
                return $Body
            }
            $Expected = '{"description":"Description goes here"}'
            $Actual = Set-ADOPSArtifactFeed -Project 'dummyProj' -FeedId 'FeedIdGoesHere' -Description 'Description goes here'
            $Actual | Should -Be $Expected
        }
        
        It 'Verifying body, upstreamEnabled true' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith { 
                return $Body
            }
            $Expected = '{"upstreamEnabled":True*'
            $Actual = Set-ADOPSArtifactFeed -Project 'dummyProj' -FeedId 'FeedIdGoesHere' -UpstreamEnabled:$true
            $Actual | Should -BeLike $Expected
        }
        
        It 'Verifying body, upstreamEnabled false' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith { 
                return $Body
            }
            $Expected = '{"upstreamEnabled":False}'
            $Actual = Set-ADOPSArtifactFeed -Project 'dummyProj' -FeedId 'FeedIdGoesHere' -UpstreamEnabled:$false
            $Actual | Should -Be $Expected
        }
        
        It 'If no body is provided, do nothing' {
            $Actual = Set-ADOPSArtifactFeed -Project 'dummyProj' -FeedId 'FeedIdGoesHere'
            Should -Invoke GetADOPSDefaultOrganization -ModuleName ADOPS -Times 0 -Exactly
            Should -Invoke InvokeADOPSRestMethod -ModuleName ADOPS -Times 0 -Exactly
        }
    }
}