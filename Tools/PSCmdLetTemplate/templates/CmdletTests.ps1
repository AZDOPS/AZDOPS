Remove-Module ADOPS -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot\..\Source\ADOPS

InModuleScope -ModuleName ADOPS {
    Describe '<%=$PLASTER_PARAM_CmdletName%> tests' {
        Context 'Command tests' {
            BeforeAll {

                $OrganizationName = 'DummyOrg'
                
                Mock -CommandName GetADOPSHeader -ModuleName ADOPS -MockWith {
                    @{
                        Header       = @{
                            'Authorization' = 'Basic Base64=='
                        }
                        Organization = $OrganizationName
                    }
                } -ParameterFilter { $OrganizationName -eq $OrganizationName }
                Mock -CommandName GetADOPSHeader -ModuleName ADOPS -MockWith {
                    @{
                        Header       = @{
                            'Authorization' = 'Basic Base64=='
                        }
                        Organization = $OrganizationName
                    }
                }

                Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                    return $InvokeSplat
                }

            }
            It 'uses InvokeADOPSRestMethod one time.' {
                <%=$PLASTER_PARAM_CmdletName%> -Organization $OrganizationName 
                Should -Invoke 'InvokeADOPSRestMethod' -ModuleName 'ADOPS' -Exactly -Times 1
            }
            It 'returns output after getting pipeline' {
                <%=$PLASTER_PARAM_CmdletName%> -Organization $OrganizationName | Should -BeOfType [pscustomobject] -Because 'InvokeADOPSRestMethod should convert the json to pscustomobject'
            }
            It 'should not throw without optional parameters' {
                { <%=$PLASTER_PARAM_CmdletName%> } | Should -Not -Throw
            }
        }

        Context 'Parameters' {
            It 'Should have parameter Organization' {
                (Get-Command <%=$PLASTER_PARAM_CmdletName%>).Parameters.Keys | Should -Contain 'Organization'
            }
            It 'Organization should not be required' {
                (Get-Command <%=$PLASTER_PARAM_CmdletName%>).Parameters['Organization'].Attributes.Mandatory | Should -Be $false
            }
        }
    }
}
