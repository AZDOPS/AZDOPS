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

    Context 'Setting Pipeline Retention Settings' {
        BeforeAll {
            $OrganizationName = 'DummyOrg'
            $Project = 'DummyProject'
            $Setting = 'artifactsRetention'

            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return @'
                {
                    "purgeArtifacts": {
                        "min": 1,
                        "max": 60,
                        "value": 40
                    },
                    "purgePullRequestRuns": {
                        "min": 1,
                        "max": 30,
                        "value": 2
                    },
                    "purgeRuns": {
                        "min": 30,
                        "max": 731,
                        "value": 30
                    },
                    "retainRunsPerProtectedBranch": null
                }
'@ | ConvertFrom-Json
            } -ParameterFilter { $Method -eq 'Patch' -and $Uri -like '*_apis/build/retention*' }

            Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'DummyOrg' }
        }

        It 'uses InvokeADOPSRestMethod single times' {
            $Values = @{ 
                $Setting = 43 
            }
            Set-ADOPSPipelineRetentionSettings -Organization $OrganizationName -Project $Project -Values $Values
            Should -Invoke 'InvokeADOPSRestMethod' -ModuleName 'ADOPS' -Exactly -Times 1
        }
        
        It 'should not throw with all parameters' {
            $Values = @{ 
                $Setting = 43 
            }
            { Set-ADOPSPipelineRetentionSettings -Organization $OrganizationName -Project $Project -Values $Values } | Should -Not -Throw
        }
        
        It 'should not throw without Organization parameter' {
            $Values = @{
                artifactsRetention = 43
            }
            { Set-ADOPSPipelineRetentionSettings -Project $Project -Values $Values } | Should -Not -Throw
        }
        
        It 'returns outputs after patching pipeline settings' {
            $Values = @{ 
                artifactsRetention = 43 
            }
            (Set-ADOPSPipelineRetentionSettings -Project $Project -Values $Values | Get-Member -MemberType NoteProperty).count | Should -Be 4
        }

        It 'should convert response type ProjectRetentionSetting into UpdateProjectRetentionSettingModel property names' {
            $Values = @{ 
                artifactsRetention           = 40
                runRetention                 = 30
                pullRequestRunRetention      = 2
                retainRunsPerProtectedBranch = 1
            }

            $Response = Set-ADOPSPipelineRetentionSettings -Organization $OrganizationName -Project $Project -Values $Values
            
            $Response.artifactsRetention | Should -BeExactly 40
            $Response.runRetention | Should -BeExactly 30
            $Response.pullRequestRunRetention | Should -BeExactly 2
            $Response.retainRunsPerProtectedBranch | Should -BeNullOrEmpty
        }
    }
}