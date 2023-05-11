param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'GetADOPSDefaultOrganization' {
    Context 'Parameters' {
        It 'Should have no parameters' {
            (Get-Command GetADOPSDefaultOrganization).Parameters.GetEnumerator() | Where-Object {
                $_.Key -notin [System.Management.Automation.Cmdlet]::CommonParameters
            } | Should -BeNullOrEmpty
        }
    }

    Context 'It should return the default organization' {
        InModuleScope -ModuleName ADOPS {
            BeforeAll {
                Mock -ModuleName ADOPS -CommandName GetADOPSConfigFile {
                    @{ 'Default' = @{ 'Identity' = 'dummyuser'; 'TenantId' = 'dummytenant'; 'Organization' = 'org1' } }
                }
            }

            It 'Token should contain organization name' {
                GetADOPSDefaultOrganization | Should -Be 'org1'
            }
        }
    }

    Context 'Bugfixes' {
        It '#149 - Add clear error message if user runs commands without first connecting' {
            InModuleScope -ModuleName ADOPS {
                InModuleScope -ModuleName ADOPS {
                    Mock -ModuleName ADOPS -CommandName GetADOPSConfigFile {
                        @{ 'Default' = @{} }
                    }
                }
                { GetADOPSDefaultOrganization } | Should -Throw -ExpectedMessage 'No default organization found! Use Connect-ADOPS or set Organization parameter.'
            }
        }
    }
}

