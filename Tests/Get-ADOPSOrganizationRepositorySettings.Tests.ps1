param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'Get-ADOPSOrganizationRepositorySettings' {
    Context 'Parameters' {
        $TestCases = @(
            @{
                Name      = 'Organization'
                Mandatory = $false
                Type      = 'string'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases {
            Get-Command Get-ADOPSOrganizationRepositorySettings | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }
    
    Context 'functionality' {
        BeforeAll {
            Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'DummyOrg' }

            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return @'
                {
                    "__wrappedArray": [
                        {
                            "__type": "VersionControlRepositoryOption:#Microsoft.TeamFoundation.Server.WebAccess.VersionControl",
                            "category": "General",
                            "defaultTextValue": null,
                            "displayHtml": "Show Gravatar images for users outside of your enterprise. This setting applies to all repositories in this project collection.",
                            "key": "GravatarEnabled",
                            "parentOptionKey": null,
                            "textValue": null,
                            "title": "Gravatar images",
                            "value": true
                        },
                        {
                            "__type": "VersionControlRepositoryOption:#Microsoft.TeamFoundation.Server.WebAccess.VersionControl",
                            "category": "General",
                            "defaultTextValue": "main",
                            "displayHtml": "New repositories will be initialized with this branch. You can change the default branch for a particular repository at any time.",
                            "key": "DefaultBranchName",
                            "parentOptionKey": null,
                            "textValue": null,
                            "title": "Default branch name for new repositories",
                            "value": false
                        },
                        {
                            "__type": "VersionControlRepositoryOption:#Microsoft.TeamFoundation.Server.WebAccess.VersionControl",
                            "category": "General",
                            "defaultTextValue": null,
                            "displayHtml": "Disable creation of TFVC repositories. You can still see and work on TFVC repositories created before.",
                            "key": "DisableTfvcRepositories",
                            "parentOptionKey": null,
                            "textValue": null,
                            "title": "Disable creation of TFVC repositories",
                            "value": true
                        }
                    ]
                }

'@ | ConvertFrom-Json
            }
        }

        It 'Should return something' {
            Get-ADOPSOrganizationRepositorySettings | Should -Not -BeNullOrEmpty
        }

        It 'StatusBadgesArePrivate Should return something' {
            (Get-ADOPSOrganizationRepositorySettings | Where-object key -eq "GravatarEnabled") | Should -Not -BeNullOrEmpty
        }
    }
}