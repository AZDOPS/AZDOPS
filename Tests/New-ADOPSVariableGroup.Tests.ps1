BeforeDiscovery {
    . $PSScriptRoot\TestHelpers.ps1
    Initialize-TestSetup
}

Describe "New-ADOPSVariableGroup" {
    It 'Has parameter <_.Name>' -TestCases @(
        @{ Name = 'VariableGroupName'; Mandatory = $true }
        @{ Name = 'VariableName'; Mandatory = $true }
        @{ Name = 'VariableValue'; Mandatory = $true }
        @{ Name = 'Project'; Mandatory = $true }
        @{ Name = 'VariableHashTable'; Mandatory = $true }
        @{ Name = 'IsSecret'; Type = [switch] }
        @{ Name = 'Description'; }
        @{ Name = 'Organization'; }
    ) {
        Get-Command -Name New-ADOPSVariableGroup | Should -HaveParameterStrict $Name -Mandatory:([bool]$Mandatory) -Type $Type
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
