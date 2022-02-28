Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot\..\Source\ADOPS -Force

Describe "New-ADOPSVariableGroup" {
    Context "General function tests" {
        It "Function exist" {
            { Get-Command -Name New-ADOPSVariableGroup -Module ADOPS -ErrorAction Stop } | Should -Not -Throw
        }
    }

    Context "Check that we have all the parameters we need" {
        It "Contains parameter: <_>" -TestCases 'Organization', 'Project', 'VariableGroupName', 'VariableName', 'VariableValue', 'IsSecret', 'Description', 'VariableHashtable' {
            (Get-Command -Name New-ADOPSVariableGroup).Parameters.Keys | Should -Contain $_
        }
    }

    Context "Adding variable group" {
        BeforeAll {
            Mock GetADOPSHeader -ModuleName ADOPS {
                @{
                    Organization = "myorg"
                }
            }
            Mock GetADOPSHeader -ModuleName ADOPS -ParameterFilter { $Organization -eq 'anotherorg' }{
                @{
                    Organization = "myorg"
                }
            }
            Mock Get-ADOPSProject -ModuleName ADOPS {
                @{
                    id = "de6a3035-0146-4ae2-81c1-68596d187cf4"
                }
            }

            Mock InvokeADOPSRestMethod -ModuleName ADOPS {
                @{
                    Uri = $Uri
                    Body = $Body
                    Method = $Method
                    Organization = $Organization
                }
            }
        }

        It "Should get organization from GetADOPSHeader when organization parameter is not used" {
            New-ADOPSVariableGroup -Organization 'anotherorg' -Project "myproject" -VariableGroupName "mygroup" -VariableName "myvar" -VariableValue "myvalue"
            Should -Invoke GetADOPSHeader -ModuleName ADOPS -ParameterFilter { $Organization -eq 'anotherorg' } -Times 1 -Exactly
        }

        It "Should validate organization using GetADOPSHeader when organization parameter is used" {
            New-ADOPSVariableGroup -Project "myproject" -VariableGroupName "mygroup" -VariableName "myvar" -VariableValue "myvalue"
            Should -Invoke GetADOPSHeader -ModuleName ADOPS -ParameterFilter { $Organization -eq 'anotherorg' } -Times 0 -Exactly
            Should -Invoke GetADOPSHeader -ModuleName ADOPS -Times 1 -Exactly
        }

        It "Should invoke with POST" {
            (New-ADOPSVariableGroup -Project "myproject" -VariableGroupName "mygroup" -VariableName "myvar" -VariableValue "myvalue").Method | Should -Be "Post"
        }

        It "Should invoke corret Uri when organization is not used" {
            (New-ADOPSVariableGroup -Project "myproject" -VariableGroupName "mygroup" -VariableName "myvar" -VariableValue "myvalue").Uri | Should -Be "https://dev.azure.com/myorg/_apis/distributedtask/variablegroups?api-version=7.1-preview.2"
        }

        It "Should invoke corret Uri when organization is used" {
            (New-ADOPSVariableGroup -Organization "someorg" -Project "myproject" -VariableGroupName "mygroup" -VariableName "myvar" -VariableValue "myvalue").Uri | Should -Be "https://dev.azure.com/someorg/_apis/distributedtask/variablegroups?api-version=7.1-preview.2"
        }        
    }
}
