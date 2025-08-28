param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'Get-ADOPSOrganizationPipelineSettings' {
    Context 'Parameters' {
        $TestCases = @(
            @{
                Name      = 'Organization'
                Mandatory = $false
                Type      = 'string'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases {
            Get-Command Get-ADOPSOrganizationPipelineSettings | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }
    
    Context 'functionality' {
        BeforeAll {
            Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'DummyOrg' }

            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return @'
                {
                    "dataProviders": {
                        "ms.vss-web.component-data": {},
                        "ms.vss-web.shared-data": null,
                        "ms.vss-build-web.pipelines-org-settings-data-provider": {
                            "statusBadgesArePrivate": true,
                            "enforceSettableVar": true,
                            "auditEnforceSettableVar": false,
                            "enforceJobAuthScope": true,
                            "enforceJobAuthScopeForReleases": true,
                            "disableInBoxTasksVar": false,
                            "disableMarketplaceTasksVar": false,
                            "disableNode6TasksVar": false,
                            "isTaskLockdownFeatureEnabled": true,
                            "hasManagePipelinePoliciesPermission": true,
                            "enforceReferencedRepoScopedToken": true,
                            "disableStageChooser": false,
                            "disableClassicPipelineCreation": false,
                            "disableClassicBuildPipelineCreation": false,
                            "disableClassicReleasePipelineCreation": false,
                            "forkProtectionEnabled": false,
                            "buildsEnabledForForks": true,
                            "enforceJobAuthScopeForForks": true,
                            "enforceNoAccessToSecretsFromForks": true,
                            "isCommentRequiredForPullRequest": true,
                            "requireCommentsForNonTeamMembersOnly": false,
                            "requireCommentsForNonTeamMemberAndNonContributors": false,
                            "enableShellTasksArgsSanitizing": false,
                            "enableShellTasksArgsSanitizingAudit": false,
                            "disableImpliedYAMLCiTrigger": false
                        }
                    }
                }
'@ | ConvertFrom-Json
            }
        }

        It 'buildsEnabledForForks Should be true' {
            (Get-ADOPSOrganizationPipelineSettings).buildsEnabledForForks | Should -Be $true
        }
    }
}