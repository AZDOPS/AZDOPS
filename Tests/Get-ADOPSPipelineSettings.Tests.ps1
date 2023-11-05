param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'Get-ADOPSPipelineSettings' {
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
                Mandatory = $false
                Type      = 'string'
            }
        )

        It 'Should have parameter <_.Name>' -TestCases $TestCases {
            Get-Command Get-ADOPSPipelineSettings | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }
    
    Context 'Getting Pipeline Settings' {
        BeforeAll {
            $OrganizationName = 'DummyOrg'
            $Project = 'DummyProject'
            $Setting = 'statusBadgesArePrivate'

            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return @'
                {
                    "enforceReferencedRepoScopedToken": true,
                    "disableClassicPipelineCreation": true,
                    "disableClassicBuildPipelineCreation": true,
                    "disableClassicReleasePipelineCreation": true,
                    "forkProtectionEnabled": true,
                    "buildsEnabledForForks": true,
                    "enforceJobAuthScopeForForks": true,
                    "enforceNoAccessToSecretsFromForks": true,
                    "isCommentRequiredForPullRequest": true,
                    "requireCommentsForNonTeamMembersOnly": false,
                    "requireCommentsForNonTeamMemberAndNonContributors": false,
                    "enableShellTasksArgsSanitizing": true,
                    "enableShellTasksArgsSanitizingAudit": false,
                    "disableImpliedYAMLCiTrigger": true,
                    "statusBadgesArePrivate": true,
                    "enforceSettableVar": true,
                    "enforceJobAuthScope": true,
                    "enforceJobAuthScopeForReleases": true,
                    "publishPipelineMetadata": true
                }
'@ | ConvertFrom-Json
            } -ParameterFilter { $Method -eq 'Get' -and $Uri -like '*build/generalsettings*' }

            Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'DummyOrg' }
        }
        
        It 'uses InvokeADOPSRestMethod single times' {
            Get-ADOPSPipelineSettings -Organization $OrganizationName -Project $Project
            Should -Invoke 'InvokeADOPSRestMethod' -ModuleName 'ADOPS' -Exactly -Times 1
        }
        It 'should not throw with mandatory parameters' {
            { Get-ADOPSPipelineSettings -Organization $OrganizationName -Project $Project } | Should -Not -Throw
        }
        It 'should not throw with optional parameters' {
            { Get-ADOPSPipelineSettings -Organization $OrganizationName -Project $Project -Name $Setting } | Should -Not -Throw
        }
        It 'should not throw without Organization parameter' {
            { Get-ADOPSPipelineSettings -Project $Project -Name $Setting } | Should -Not -Throw
        }
        It 'returns single output after passing setting name' {
            (Get-ADOPSPipelineSettings -Organization $OrganizationName -Project $Project -Name $Setting) | Should -BeOfType Boolean
        }
        It 'returns multiple outputs after getting pipelines' {
            (Get-ADOPSPipelineSettings -Organization $OrganizationName -Project $Project | Get-Member -MemberType NoteProperty).count | Should -Be 19
        }
    }
}
