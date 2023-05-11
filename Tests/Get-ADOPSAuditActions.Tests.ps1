param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'Get-ADOPSAuditActions' {
    Context 'Parameters' {
        $TestCases = @(
            @{
                Name = 'Organization'
                Mandatory = $false
                Type = 'string'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command Get-ADOPSAuditActions | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }
    
    Context 'functionality' {
        BeforeAll {
            Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'DummyOrg' }

            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return @'
                [
                    {
                      "area": "Permissions",
                      "category": "modify",
                      "actionId": "Security.ModifyPermission"
                    },
                    {
                      "area": "Permissions",
                      "category": "modify",
                      "actionId": "Security.ResetPermission"
                    },
                    {
                      "area": "Permissions",
                      "category": "remove",
                      "actionId": "Security.RemovePermission"
                    }
                  ]                  
'@ | ConvertFrom-Json
            }
        }
        
        It 'Should not get organization from GetADOPSDefaultOrganization when organization parameter is used' {
            Get-ADOPSAuditActions -Organization 'anotherorg'
            Should -Invoke GetADOPSDefaultOrganization -ModuleName ADOPS -Times 0 -Exactly
        }

        It 'Should get organization using GetADOPSDefaultOrganization when organization parameter is not used' {
            Get-ADOPSAuditActions
            Should -Invoke GetADOPSDefaultOrganization -ModuleName ADOPS -Times 1 -Exactly
        }

        It 'Should return something' {
            Get-ADOPSAuditActions | Should -Not -BeNullOrEmpty
        }
    }
}