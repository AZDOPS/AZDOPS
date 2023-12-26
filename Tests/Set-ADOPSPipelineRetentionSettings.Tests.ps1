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

#             Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
#                 return @'
#                 {
#                     "purgeArtifacts": 43,
#                     "purgePullRequestRuns": 2,
#                     "purgeRuns": 30,
#                     "retainRunsPerProtectedBranch": null
#                 }
# '@ | ConvertFrom-Json
#             } -ParameterFilter { $Method -eq 'Patch' -and $Uri -like '*_apis/build/retention*' }

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
        It 'should convert values into correct API format' {

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

            Set-ADOPSPipelineRetentionSettings -Organization $OrganizationName -Project $Project -Values @{ 
                artifactsRetention           = 40
                runRetention                 = 30
                pullRequestRunRetention      = 2
                retainRunsPerProtectedBranch = 1
            }
            Should -Invoke 'InvokeADOPSRestMethod' -ModuleName ADOPS -ParameterFilter { 
                $ParsedBody = $Body | ConvertFrom-Json -Depth 3
                
                $ParsedBody.artifactsRetention.min | Should -BeNullOrEmpty
                $ParsedBody.artifactsRetention.max | Should -BeNullOrEmpty
                $ParsedBody.artifactsRetention.value | Should -BeExactly 40
 
                $ParsedBody.runRetention.min | Should -BeNullOrEmpty
                $ParsedBody.runRetention.max | Should -BeNullOrEmpty
                $ParsedBody.runRetention.value | Should -BeExactly 30

                $ParsedBody.pullRequestRunRetention.min | Should -BeNullOrEmpty
                $ParsedBody.pullRequestRunRetention.max | Should -BeNullOrEmpty
                $ParsedBody.pullRequestRunRetention.value | Should -BeExactly 2
                
                $ParsedBody.retainRunsPerProtectedBranch.min | Should -BeNullOrEmpty
                $ParsedBody.retainRunsPerProtectedBranch.max | Should -BeNullOrEmpty
                $ParsedBody.retainRunsPerProtectedBranch.value | Should -BeExactly 1

                $true
            } -Times 1 -Exactly
        }
    }
}