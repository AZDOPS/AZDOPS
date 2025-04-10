param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'Get-ADOPSOrganizationAdvancedSecurity' {
    Context 'Parameters' {
        $TestCases = @(
            @{
                Name      = 'Organization'
                Mandatory = $false
                Type      = 'string'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases {
            Get-Command Get-ADOPSOrganizationAdvancedSecurity | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }
    
    Context 'functionality' {
        BeforeAll {
            Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'DummyOrg' }

            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return @'
                {
                    "enableOnCreate": false,
                    "reposEnablementStatus": [
                        {
                        "projectId": "45a5ae4f-effa-4a15-b87b-8684f9d66349",
                        "repositoryId": "2b463ebb-fca8-466f-9b1b-29b424776385",
                        "advSecEnablementLastChangedDate": null,
                        "advSecEnabled": null,
                        "advSecEnablementFeatures": {
                            "dependabotEnabled": false,
                            "forceRepoSecretScanning": null,
                            "dependencyScanningInjectionEnabled": null,
                            "codeQLEnabled": null,
                            "autoEnableNewProjectOrRepos": null
                        }
                        }
                    ]
                    }
'@ | ConvertFrom-Json
            }
        }

        It 'Should return something' {
            Get-ADOPSOrganizationAdvancedSecurity | Should -Not -BeNullOrEmpty
        }

        It 'StatusBadgesArePrivate Should return something' {
            (Get-ADOPSOrganizationAdvancedSecurity).enableOnCreate | Should -Not -BeNullOrEmpty
        }
    }
}