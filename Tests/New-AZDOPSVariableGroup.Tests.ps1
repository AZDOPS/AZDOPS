Remove-Module AZDOPS -Force -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot\..\Source\AZDOPS -Force

Describe "New-AZDOPSVariableGroup" {
    Context "General function tests" {
        It "Function exist" {
            { Get-Command -Name New-AZDOPSVariableGroup -Module AZDOPS -ErrorAction Stop } | Should -Not -Throw
        }
    }

    Context "Check that we have all the parameters we need" {
        It "Contains parameter: <_>" -TestCases 'Organization', 'Project', 'VariableGroupName', 'VariableName', 'VariableValue', 'IsSecret', 'Description', 'VariableHashtable' {
            (Get-Command -Name New-AZDOPSVariableGroup).Parameters.Keys | Should -Contain $_
        }
    }

    Context "Adding variable group" {
        BeforeAll {
            Mock GetAZDOPSHeader -ModuleName AZDOPS {
                @{
                    Organization = "myorg"
                }
            }
            Mock GetAZDOPSHeader -ModuleName AZDOPS -ParameterFilter { $Organization -eq 'anotherorg' }{
                @{
                    Organization = "myorg"
                }
            }
            Mock Get-AZDOPSProject -ModuleName AZDOPS {
                @{
                    id = "de6a3035-0146-4ae2-81c1-68596d187cf4"
                }
            }

            Mock InvokeAZDOPSRestMethod -ModuleName AZDOPS {
                @{
                    Uri = $Uri
                    Body = $Body
                    Method = $Method
                    Organization = $Organization
                }
            }
        }

        It "Should get organization from GetAZDOPSHeader when organization parameter is not used" {
            New-AZDOPSVariableGroup -Organization 'anotherorg' -Project "myproject" -VariableGroupName "mygroup" -VariableName "myvar" -VariableValue "myvalue"
            Should -Invoke GetAZDOPSHeader -ModuleName AZDOPS -ParameterFilter { $Organization -eq 'anotherorg' } -Times 1 -Exactly
        }

        It "Should validate organization using GetAZDOPSHeader when organization parameter is used" {
            New-AZDOPSVariableGroup -Project "myproject" -VariableGroupName "mygroup" -VariableName "myvar" -VariableValue "myvalue"
            Should -Invoke GetAZDOPSHeader -ModuleName AZDOPS -ParameterFilter { $Organization -eq 'anotherorg' } -Times 0 -Exactly
            Should -Invoke GetAZDOPSHeader -ModuleName AZDOPS -Times 1 -Exactly
        }

        It "Should invoke with POST" {
            (New-AZDOPSVariableGroup -Project "myproject" -VariableGroupName "mygroup" -VariableName "myvar" -VariableValue "myvalue").Method | Should -Be "Post"
        }

        It "Should invoke corret Uri when organization is not used" {
            (New-AZDOPSVariableGroup -Project "myproject" -VariableGroupName "mygroup" -VariableName "myvar" -VariableValue "myvalue").Uri | Should -Be "https://dev.azure.com/myorg/_apis/distributedtask/variablegroups?api-version=7.1-preview.2"
        }

        It "Should invoke corret Uri when organization is used" {
            (New-AZDOPSVariableGroup -Organization "someorg" -Project "myproject" -VariableGroupName "mygroup" -VariableName "myvar" -VariableValue "myvalue").Uri | Should -Be "https://dev.azure.com/someorg/_apis/distributedtask/variablegroups?api-version=7.1-preview.2"
        }        
    }
}
