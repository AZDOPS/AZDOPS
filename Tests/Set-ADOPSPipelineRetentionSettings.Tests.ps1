param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'Set-ADOPSPipelineRetentionSettings' {
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
                Name      = 'Values'
                Mandatory = $true
                Type      = 'object'
            }
        )

        It 'Should have parameter <_.Name>' -TestCases $TestCases {
            Get-Command Set-ADOPSPipelineRetentionSettings | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }

    Context 'Getting Pipeline Retention Settings' {
        BeforeAll {
            $OrganizationName = 'DummyOrg'
            $Project = 'DummyProject'
            $Setting = 'artifactsRetention'

            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return @'
                {
                    "purgeArtifacts": 43,
                    "purgePullRequestRuns": 2,
                    "purgeRuns": 30,
                    "retainRunsPerProtectedBranch": null
                }
'@ | ConvertFrom-Json
            } -ParameterFilter { $Method -eq 'Patch' -and $Uri -like '*_apis/build/retention*' }

            Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'DummyOrg' }
        }

        It 'uses InvokeADOPSRestMethod single times' {
            Set-ADOPSPipelineRetentionSettings -Organization $OrganizationName -Project $Project -Values @{ $Setting = 43 }
            Should -Invoke 'InvokeADOPSRestMethod' -ModuleName 'ADOPS' -Exactly -Times 1
        }
        It 'should not throw with all parameters' {
            { Set-ADOPSPipelineRetentionSettings -Organization $OrganizationName -Project $Project -Values @{ $Setting = 43 } } | Should -Not -Throw
        }
        It 'should not throw without Organization parameter' {
            { Set-ADOPSPipelineRetentionSettings -Project $Project -Values @{ artifactsRetention = 43 } } | Should -Not -Throw
        }
        It 'returns outputs after patching pipeline settings' {
            (Set-ADOPSPipelineRetentionSettings -Project $Project -Values @{ artifactsRetention = 43 } | Get-Member -MemberType NoteProperty).count | Should -Be 4
        }
    }
}