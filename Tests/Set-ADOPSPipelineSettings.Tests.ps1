param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'Set-ADOPSPipelineSettings' {
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
                Name      = 'Value'
                Mandatory = $true
                Type      = 'boolean'
            },
            @{
                Name      = 'Values'
                Mandatory = $true
                Type      = 'object'
            }
        )

        It 'Should have parameter <_.Name>' -TestCases $TestCases {
            Get-Command Set-ADOPSPipelineSettings | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }

        It 'Should have two parameterSets' {
            $c = Get-Command Set-ADOPSPipelineSettings
            $c.ParameterSets.Name.Count | Should -Be 2
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
            } -ParameterFilter { $Method -eq 'Patch' -and $Uri -like '*build/generalsettings*' }

            Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'DummyOrg' }
        }
        
        It 'uses InvokeADOPSRestMethod single times' {
            Set-ADOPSPipelineSettings -Organization $OrganizationName -Project $Project -Values @{ statusBadgesArePrivate = $false }
            Should -Invoke 'InvokeADOPSRestMethod' -ModuleName 'ADOPS' -Exactly -Times 1
        }
        It 'should not throw with parameters set value' {
            { Set-ADOPSPipelineSettings -Organization $OrganizationName -Project $Project -Name $Setting -Value $false } | Should -Not -Throw
        }
        It 'should not throw with parameters set multiple values' {
            { Set-ADOPSPipelineSettings -Organization $OrganizationName -Project $Project -Values @{ $Setting = $false } } | Should -Not -Throw
        }
        It 'should not throw without Organization parameter' {
            { Set-ADOPSPipelineSettings -Project $Project -Name $Setting -Value $false } | Should -Not -Throw
        }
        It 'returns outputs after patching pipeline settings' {
            (Set-ADOPSPipelineSettings -Project $Project -Name $Setting -Value $false | Get-Member -MemberType NoteProperty).count | Should -Be 19
        }
    }
}
