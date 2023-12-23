param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'Get-ADOPSPipelineRetentionSettings' {
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
            }
        )

        It 'Should have parameter <_.Name>' -TestCases $TestCases {
            Get-Command Get-ADOPSPipelineRetentionSettings | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }

    Context 'Getting Pipeline Retention Settings' {
        BeforeAll {
            $OrganizationName = 'DummyOrg'
            $Project = 'DummyProject'

            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return @'
                {
                    "purgeArtifacts": 43,
                    "purgePullRequestRuns": 2,
                    "purgeRuns": 30,
                    "retainRunsPerProtectedBranch": null
                }
'@ | ConvertFrom-Json
            } -ParameterFilter { $Method -eq 'Get' -and $Uri -like '*_apis/build/retention*' }

            Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'DummyOrg' }
        }

        It 'uses InvokeADOPSRestMethod single times' {
            Get-ADOPSPipelineRetentionSettings -Organization $OrganizationName -Project $Project
            Should -Invoke 'InvokeADOPSRestMethod' -ModuleName 'ADOPS' -Exactly -Times 1
        }
        It 'should not throw with mandatory parameters' {
            { Get-ADOPSPipelineRetentionSettings -Organization $OrganizationName -Project $Project } | Should -Not -Throw
        }
        It 'should not throw without Organization parameter' {
            { Get-ADOPSPipelineRetentionSettings -Project $Project } | Should -Not -Throw
        }
        It 'returns settings after getting pipelines' {
            (Get-ADOPSPipelineRetentionSettings -Organization $OrganizationName -Project $Project | Get-Member -MemberType NoteProperty).count | Should -Be 4
        }
    }
}