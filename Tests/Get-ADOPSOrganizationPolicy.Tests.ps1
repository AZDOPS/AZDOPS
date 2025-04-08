param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'Get-ADOPSOrganizationPolicy' {
    Context 'Parameters' {
        $TestCases = @(
            @{
                Name      = 'Organization'
                Mandatory = $false
                Type      = 'string'
            },
            @{
                Name      = 'PolicyCategory'
                Mandatory = $false
                Type      = 'string'
            }
        )

        It 'Should have parameter <_.Name>' -TestCases $TestCases {
            Get-Command Get-ADOPSOrganizationPolicy | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }
    
    Context 'Getting Pipeline Settings' {
        BeforeAll {
            $OrganizationName = 'DummyOrg'
            $PolicyCategory = 'User'

            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return @'
                {
                    "fps": {
                        "dataProviders": {
                            "data:" {
                                "ms.vss-admin-web.organization-policies-data-provider": {
                                    "policies": {
                                        {
                                            "applicationConnection": [
                                            {
                                                "policy": {
                                                    "name": "Policy.DisallowBasicAuthentication",
                                                    "value": false,
                                                    "effectiveValue": true,
                                                    "parentPolicy": {
                                                        "name": "Policy.DisallowBasicAuthentication",
                                                        "value": true,
                                                        "effectiveValue": false,
                                                        "isValueUndefined": true
                                                    }
                                                },
                                                "learnMoreLink": "https://aka.ms/vstspolicyaltauth",
                                                "description": "Alternate authentication credentials",
                                                "applicableServiceHost": 1
                                            },
                                            {
                                                "policy": {
                                                    "name": "Policy.DisallowOAuthAuthentication",
                                                    "value": false,
                                                    "effectiveValue": true,
                                                    "isValueUndefined": true,
                                                    "parentPolicy": {
                                                        "name": "Policy.DisallowOAuthAuthentication",
                                                        "value": false,
                                                        "effectiveValue": true,
                                                        "isValueUndefined": true
                                                    }
                                                },
                                                "learnMoreLink": "https://aka.ms/vstspolicyoauth",
                                                "description": "Third-party application access via OAuth",
                                                "applicableServiceHost": 1
                                            },
                                            {
                                                "policy": {
                                                    "name": "Policy.DisallowSecureShell",
                                                    "value": false,
                                                    "effectiveValue": true,
                                                    "isValueUndefined": true,
                                                    "parentPolicy": {
                                                        "name": "Policy.DisallowSecureShell",
                                                        "value": false,
                                                        "effectiveValue": true,
                                                        "isValueUndefined": true
                                                    }
                                                },
                                                "learnMoreLink": "https://aka.ms/vstspolicyssh",
                                                "description": "SSH authentication",
                                                "applicableServiceHost": 1
                                            }
                                            ],
                                            "security": [
                                            {
                                                "policy": {
                                                    "name": "Policy.LogAuditEvents",
                                                    "value": true,
                                                    "effectiveValue": true,
                                                    "parentPolicy": {
                                                        "name": "Policy.LogAuditEvents",
                                                        "value": false,
                                                        "effectiveValue": false,
                                                        "isValueUndefined": true
                                                    }
                                                },
                                                "learnMoreLink": "https://aka.ms/log-audit-events",
                                                "description": "Log Audit Events"
                                            },
                                            {
                                                "policy": {
                                                    "name": "Policy.AllowAnonymousAccess",
                                                    "value": false,
                                                    "effectiveValue": false,
                                                    "parentPolicy": {
                                                        "name": "Policy.AllowAnonymousAccess",
                                                        "value": false,
                                                        "effectiveValue": false,
                                                        "isValueUndefined": true
                                                    }
                                                },
                                                "learnMoreLink": "https://aka.ms/vsts-anon-access",
                                                "description": "Allow public projects",
                                                "applicableServiceHost": 3
                                            },
                                            {
                                                "policy": {
                                                    "name": "Policy.ArtifactsExternalPackageProtectionToken",
                                                    "value": true,
                                                    "effectiveValue": true,
                                                    "isValueUndefined": true,
                                                    "parentPolicy": {
                                                        "name": "Policy.ArtifactsExternalPackageProtectionToken",
                                                        "value": true,
                                                        "effectiveValue": true,
                                                        "isValueUndefined": true
                                                    }
                                                },
                                                "learnMoreLink": "https://aka.ms/upstreamBehaviorBlog",
                                                "description": "Additional protections when using public package registries"
                                            },
                                            {
                                                "policy": {
                                                    "name": "Policy.EnforceAADConditionalAccess",
                                                    "value": true,
                                                    "effectiveValue": true,
                                                    "parentPolicy": {
                                                        "name": "Policy.EnforceAADConditionalAccess",
                                                        "value": false,
                                                        "effectiveValue": false,
                                                        "isValueUndefined": true
                                                    }
                                                },
                                                "learnMoreLink": "https://aka.ms/visual-studio-conditional-access-policy",
                                                "description": "Enable IP Conditional Access policy validation",
                                                "applicableServiceHost": 3
                                            }
                                            ],
                                            "user": [
                                            {
                                                "policy": {
                                                    "name": "Policy.DisallowAadGuestUserAccess",
                                                    "value": false,
                                                    "effectiveValue": true,
                                                    "parentPolicy": {
                                                        "name": "Policy.DisallowAadGuestUserAccess",
                                                        "value": false,
                                                        "effectiveValue": true,
                                                        "isValueUndefined": true
                                                    }
                                                },
                                                "learnMoreLink": "https://aka.ms/vstspolicyguest",
                                                "description": "External guest access",
                                                "applicableServiceHost": 3
                                            },
                                            {
                                                "policy": {
                                                    "name": "Policy.AllowTeamAdminsInvitationsAccessToken",
                                                    "value": false,
                                                    "effectiveValue": false,
                                                    "parentPolicy": {
                                                        "name": "Policy.AllowTeamAdminsInvitationsAccessToken",
                                                        "value": true,
                                                        "effectiveValue": true,
                                                        "isValueUndefined": true
                                                    }
                                                },
                                                "learnMoreLink": "https://aka.ms/azure-devops-invitations-policy",
                                                "description": "Allow team and project administrators to invite new users"
                                            },
                                            {
                                                "policy": {
                                                    "name": "Policy.AllowRequestAccessToken",
                                                    "value": false,
                                                    "effectiveValue": false,
                                                    "parentPolicy": {
                                                        "name": "Policy.AllowRequestAccessToken",
                                                        "value": true,
                                                        "effectiveValue": true,
                                                        "isValueUndefined": true
                                                    }
                                                },
                                                "learnMoreLink": "https://go.microsoft.com/fwlink/?linkid=2113172",
                                                "description": "Request access",
                                                "applicableServiceHost": 1
                                            }
                                            ],
                                            "privacy": [
                                            {
                                                "policy": {
                                                    "name": "Policy.AllowFeedbackCollection",
                                                    "value": true,
                                                    "effectiveValue": true,
                                                    "isValueUndefined": true,
                                                    "parentPolicy": {
                                                        "name": "Policy.AllowFeedbackCollection",
                                                        "value": true,
                                                        "effectiveValue": true,
                                                        "isValueUndefined": true
                                                    }
                                                },
                                                "learnMoreLink": "https://aka.ms/ADOPrivacyPolicy",
                                                "description": "Allow Microsoft to collect feedback from users",
                                                "applicableServiceHost": 2
                                            }
                                            ]
                                        }

                                    }
                                }
                            }
                        }
                    }
                }
'@ | ConvertFrom-Json
            } -ParameterFilter { $Method -eq 'Get' -and $Uri -like '*_settings/organizationPolicy*' }

            Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'DummyOrg' }
        }
        
        It 'uses InvokeADOPSRestMethod single times' {
            Get-ADOPSOrganizationPolicy -Organization $OrganizationName
            Should -Invoke 'InvokeADOPSRestMethod' -ModuleName 'ADOPS' -Exactly -Times 1
        }
        It 'should not throw with mandatory parameters' {
            { Get-ADOPSOrganizationPolicy -Organization $OrganizationName -PolicyCategory $PolicyCategory } | Should -Not -Throw
        }
        It 'returns settings after getting pipelines' {
            (Get-ADOPSOrganizationPolicy -Organization $OrganizationName -PolicyCategory $PolicyCategory | Get-Member -MemberType NoteProperty).count | Should -Be 3
        }
    }
}
