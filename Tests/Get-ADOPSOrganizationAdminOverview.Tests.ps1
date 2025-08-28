param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'Get-ADOPSOrganizationAdminOverview' {
    Context 'Parameters' {
        $TestCases = @(
            @{
                Name      = 'Organization'
                Mandatory = $false
                Type      = 'string'
            },
            @{
                Name      = 'ContributionIds'
                Mandatory = $false
                Type      = 'String[]'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases {
            Get-Command Get-ADOPSOrganizationAdminOverview | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
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
                        "ms.vss-admin-web.organization-admin-overview-delay-load-data-provider": {
                            "hasDeletePermissions": true,
                            "hasModifyPermissions": true,
                            "currentOwner": {
                                "name": "Organization Owner",
                                "id": "a5971806-86aa-44a3-a9c9-2f52180f1570",
                                "email": "Org.Owner@contoso.com"
                            },
                            "currentUserId": "07ebeea2-722f-6821-8844-a5f5783e568b",
                            "organizationTakeover": {},
                            "showDomainMigration": true,
                            "disableDomainMigration": false,
                            "devOpsDomainUrls": true,
                            "targetDomainUrl": "https://organizationName.visualstudio.com/"
                        }
                    }
                }             
'@ | ConvertFrom-Json
            }
        }

        It 'Should return something' {
            Get-ADOPSOrganizationAdminOverview | Should -Not -BeNullOrEmpty
        }
    }
}