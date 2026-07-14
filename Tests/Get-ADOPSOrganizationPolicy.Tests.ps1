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
            },
            @{
                Name      = 'Force'
                Mandatory = $false
                Type      = 'switch'
            }
        )

        It 'Should have parameter <_.Name>' -TestCases $TestCases {
            Get-Command Get-ADOPSOrganizationPolicy | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }
    
    Context 'Getting Organization Policies' {
        BeforeAll {
            $OrganizationName = 'DummyOrg'
            $PolicyCategory = 'User'

            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return @'
                {
    "fps": {
        "dataProviders": {
            "data": {
                "ms.vss-admin-web.organization-policies-data-provider": {
                    "policies": {
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
'@ | ConvertFrom-Json -depth 100
            } -ParameterFilter { $Method -eq 'Get' -and $Uri -like '*organizationPolicy*' }

            Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'DummyOrg' }
        }
        
        It 'uses InvokeADOPSRestMethod single times' {
            Get-ADOPSOrganizationPolicy -Organization $OrganizationName -Force
            Should -Invoke 'InvokeADOPSRestMethod' -ModuleName 'ADOPS' -Exactly -Times 1
        }
        It 'should not throw with mandatory parameters' {
            { Get-ADOPSOrganizationPolicy -Organization $OrganizationName -Force -PolicyCategory $PolicyCategory } | Should -Not -Throw
        }
        It 'should return selected policies in category' {
            (Get-ADOPSOrganizationPolicy -Organization $OrganizationName -Force -PolicyCategory $PolicyCategory).count | Should -Be 3
        }
        It 'should return all policies for the organization' {
            (Get-ADOPSOrganizationPolicy -Organization $OrganizationName -Force).count | Should -Be 11
        }
        It 'should return Security policies when PolicyCategory is Security' {
            (Get-ADOPSOrganizationPolicy -Organization $OrganizationName -Force -PolicyCategory 'Security').count | Should -Be 4
        }
        It 'should return Privacy policies when PolicyCategory is Privacy' {
            (Get-ADOPSOrganizationPolicy -Organization $OrganizationName -Force -PolicyCategory 'Privacy').count | Should -Be 1
        }
        It 'should return ApplicationConnection policies when PolicyCategory is ApplicationConnection' {
            (Get-ADOPSOrganizationPolicy -Organization $OrganizationName -Force -PolicyCategory 'ApplicationConnection').count | Should -Be 3
        }
        It 'should use default organization when Organization is not provided' {
            Get-ADOPSOrganizationPolicy -Force
            Should -Invoke 'GetADOPSDefaultOrganization' -ModuleName 'ADOPS' -Exactly -Times 1
        }
        It 'should not call API and output warning when Force is not used and runInsecureApis is false' {
            Get-ADOPSOrganizationPolicy -Organization $OrganizationName 4>&1
            Should -Invoke 'InvokeADOPSRestMethod' -ModuleName 'ADOPS' -Exactly -Times 0
        }
        It 'should write warning to verbose stream when Force is not used and runInsecureApis is false' {
            $verboseOutput = Get-ADOPSOrganizationPolicy -Organization $OrganizationName 4>&1
            $verboseOutput | Should -Match 'This function uses unsupported APIs'
        }
    }
}
