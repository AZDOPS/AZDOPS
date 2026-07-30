param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'Get-ADOPSOrganizationCopilotCodeReview' {
    Context 'Parameters' {
        $TestCases = @(
            @{
                Name      = 'Organization'
                Mandatory = $false
                Type      = 'string'
            }
        )

        It 'Should have parameter <_.Name>' -TestCases $TestCases {
            Get-Command Get-ADOPSOrganizationCopilotCodeReview | Should-HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
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
                        "ms.vss-code-web.copilot-code-review-org-settings-data-provider": {
                            "isEnabled": true,
                            "agentPoolId": 9
                        }
                    }
                }
'@ | ConvertFrom-Json
            }
        }

        It 'isEnabled Should be true' {
            (Get-ADOPSOrganizationCopilotCodeReview).isEnabled | Should-Be $true
        }

        It 'agentPoolId Should be 9' {
            (Get-ADOPSOrganizationCopilotCodeReview).agentPoolId | Should-Be 9
        }

        It 'Should get the organization from the saved context when not specified' {
            Get-ADOPSOrganizationCopilotCodeReview
            Should-Invoke GetADOPSDefaultOrganization -Times 1 -Exactly -ModuleName ADOPS
        }

        It 'Should not look up the default organization when one is specified' {
            Get-ADOPSOrganizationCopilotCodeReview -Organization 'AnotherOrg'
            Should-NotInvoke GetADOPSDefaultOrganization -ModuleName ADOPS
        }

        It 'Should post to the HierarchyQuery endpoint for the given organization' {
            Get-ADOPSOrganizationCopilotCodeReview -Organization 'AnotherOrg'
            Should-Invoke InvokeADOPSRestMethod -Times 1 -Exactly -ModuleName ADOPS -ParameterFilter {
                $Method -eq 'Post' -and $Uri -eq 'https://dev.azure.com/AnotherOrg/_apis/Contribution/HierarchyQuery?api-version=7.1-preview'
            }
        }

        It 'Should request the settings-options contribution' {
            Get-ADOPSOrganizationCopilotCodeReview
            Should-Invoke InvokeADOPSRestMethod -Times 1 -Exactly -ModuleName ADOPS -ParameterFilter {
                $Body -match 'ms\.vss-code-web\.settings-options'
            }
        }
    }
}