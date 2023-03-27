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
            Mock -CommandName GetADOPSHeader -ModuleName ADOPS -MockWith {
                @{
                    Header       = @{
                        'Authorization' = 'Basic Base64=='
                    }
                    Organization = $OrganizationName
                }
            } -ParameterFilter { $OrganizationName -eq 'Organization' }
            Mock -CommandName GetADOPSHeader -ModuleName ADOPS -MockWith {
                @{
                    Header       = @{
                        'Authorization' = 'Basic Base64=='
                    }
                    Organization = $OrganizationName
                }
            }

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
        
        It 'Should get organization from GetADOPSHeader when organization parameter is used' {
            Get-ADOPSAuditActions -Organization 'anotherorg'
            Should -Invoke GetADOPSHeader -ModuleName ADOPS -ParameterFilter { $Organization -eq 'anotherorg' } -Times 1 -Exactly
        }

        It 'Should validate organization using GetADOPSHeader when organization parameter is not used' {
            Get-ADOPSAuditActions
            Should -Invoke GetADOPSHeader -ModuleName ADOPS -ParameterFilter { $Organization -eq 'anotherorg' } -Times 0 -Exactly
            Should -Invoke GetADOPSHeader -ModuleName ADOPS -Times 1 -Exactly
        }

        It 'Should return something' {
            Get-ADOPSAuditActions | Should -Not -BeNullOrEmpty
        }
    }
}