param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'New-ADOPSArtifactFeed' {
    Context 'Parameters' {
        $TestCases = @(
            @{
                Name      = 'Organization'
                Mandatory = $false
                Type      = 'string'
            },
            @{
                Name      = 'Project'
                Mandatory = $true
                Type      = 'string'
            },
            @{
                Name      = 'Name'
                Mandatory = $true
                Type      = 'string'
            },
            @{
                Name      = 'Description'
                Mandatory = $false
                Type      = 'string'
            },
            @{
                Name      = 'IncludeUpstream'
                Mandatory = $false
                Type      = 'switch'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases {
            Get-Command New-ADOPSArtifactFeed | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }
    
    Context 'functionality' {
        BeforeAll {
            InModuleScope -ModuleName ADOPS {
                Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'DummyOrg' }
    
                Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                    return $InvokeSplat
                }
                
                Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                    @{
                        Id = "000a00a0-aa00-0a00-000a-0a000aa00aaa"
                        Descriptor = @{
                          IdentityType = "Microsoft.TeamFoundation.ServiceIdentity"
                          Identifier = "1b1111b1-11b1-1b11-11bb-b11bbb11111b:Build:cc2c2c2c-cc22-2c22-22c2-c2c2cc222cc2"
                        }
                      }
                } -ParameterFilter {
                    $uri -like "https://vssps.dev.azure.com/*/_apis/Identities?identityIds=*"
                }

                Mock -CommandName Get-ADOPSUser -ModuleName ADOPS -MockWith {
                    @(
                        @{
                            displayName = 'DummyProj build service (DummyOrg)'
                            originId = '00000000-aaaa-0a0a-aaaa-a000000aa0a0'
                        },
                        @{
                            displayName = 'user2'
                            originId = 'b111bbbb-bb11-1111-11bb-11b1111b1bbb'
                        }
                    )
                }
            }
        }
        
        It 'If organization is given, it should not call GetADOPSDefaultOrganization' {
            $r = New-ADOPSArtifactFeed -Organization 'DummyOrg' -Project 'DummyProj' -Name 'FeedName'
            Should -Invoke -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -Times 0 -Exactly
        }
        It 'If organization is not given, it should call GetADOPSDefaultOrganization' {
            $r = New-ADOPSArtifactFeed -Project 'DummyProj' -Name 'FeedName'
            Should -Invoke -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -Times 1 -Exactly
        }

        It 'Should call Get-ADOPSUser once to get the build account' {
            $r = New-ADOPSArtifactFeed -Project 'DummyProj' -Name 'FeedName'
            Should -Invoke -CommandName Get-ADOPSUser -ModuleName ADOPS -Times 1 -Exactly
        }

        It 'Should call InvokeADOPSRestMethod once to get the build account descriptor' {
            $r = New-ADOPSArtifactFeed -Project 'DummyProj' -Name 'FeedName' -Organization 'DummyOrg'
            Should -Invoke -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -Times 1 -Exactly -ParameterFilter {
                $Uri -like "https://vssps.dev.azure.com/*/_apis/Identities?identityIds=*"
            }
        }

        It 'If no matching identity is found, dont try to get build account descriptor' {
            $r = New-ADOPSArtifactFeed -Project 'notExistingProj' -Name 'FeedName' -Organization 'DummyOrg'
            Should -Invoke -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -Times 0 -Exactly -ParameterFilter {
                $Uri -like "https://vssps.dev.azure.com/*/_apis/Identities?identityIds=*"
            }
        }
        
        It 'Verify URI is set correct' {
            $required = 'https://feeds.dev.azure.com/DummyOrg/DummyProj/_apis/packaging/feeds?api-version=7.2-preview.1'
            $actual = New-ADOPSArtifactFeed -Project 'DummyProj' -Name 'FeedName'
            $actual.Uri | Should -Be $required
        }
        
        It 'Verify Method is set correct' {
            $required = 'Post'
            $actual = New-ADOPSArtifactFeed -Project 'DummyProj' -Name 'FeedName'
            $actual.Method | Should -Be $required
        }
        
        It 'Verify baseline body is set correct' {
            # Use not found org to get the baseline body only, not including security settings.
            $required = '{"name":"FeedName","upstreamEnabled":false,"hideDeletedPackageVersions":true,"project":{"visibility":"Private"}}'
            $actual = New-ADOPSArtifactFeed -Project 'DummyProj' -Name 'FeedName' -Organization 'NotFound'
            $actual.Body | Should -Be $required
        }
        
        It 'Verify body is set correct, UpstreamEnabled' {
            $actual = (New-ADOPSArtifactFeed -Project 'DummyProj' -Name 'FeedName' -IncludeUpstream).Body | ConvertFrom-Json
            $actual.upstreamSources.Count | Should -Be 9
        }
        
        It 'Verify body is set correct, Description' {
            $actual = (New-ADOPSArtifactFeed -Project 'DummyProj' -Name 'FeedName' -Description 'Test Description').Body | ConvertFrom-Json
            $actual.Description | Should -Be 'Test Description'
        }
        
        It 'Verify body is set correct, permissions' {
            $actual = (New-ADOPSArtifactFeed -Project 'DummyProj' -Name 'FeedName' -IncludeUpstream).Body | ConvertFrom-Json
            $actual.permissions.Count | Should -Be 1
        }
    }
}