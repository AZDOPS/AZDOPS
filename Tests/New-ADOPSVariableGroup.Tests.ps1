BeforeDiscovery {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSScriptRoot\..\Source\ADOPS -Force
}

Describe "New-ADOPSVariableGroup" {
    Context "Parameters" {
        $TestCases = @(
            @{
                Name = 'Organization'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'Project'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'VariableGroupName'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'VariableName'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'VariableValue'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'IsSecret'
                Mandatory = $false
                Type = 'switch'
            },
            @{
                Name = 'Description'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'VariableHashtable'
                Mandatory = $false
                Type = 'hashtable[]'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command New-ADOPSVariableGroup | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }

        It 'Should throw if VariableHashtable is used and not correct, to many keys' {
            {New-ADOPSVariableGroup -Project "myproject" -VariableGroupName "mygroup" -VariableHashtable @{
                Name = 'Name'
                IsSecret = $True
                Value = 'Value'
                OneTooMany = $True
            }} | Should -Throw
        }

        It 'Should throw if VariableHashtable is used and not correct, missing Name' {
            {New-ADOPSVariableGroup -Project "myproject" -VariableGroupName "mygroup" -VariableHashtable @{
                IsSecret = $True
                Value = 'Value'
            }} | Should -Throw
        }

        It 'Should throw if VariableHashtable is used and not correct, missing IsSecret' {
            {New-ADOPSVariableGroup -Project "myproject" -VariableGroupName "mygroup" -VariableHashtable @{
                Name = 'Name'
                Value = 'Value'
            }} | Should -Throw
        }

        It 'Should throw if VariableHashtable is used and not correct, missing Value' {
            {New-ADOPSVariableGroup -Project "myproject" -VariableGroupName "mygroup" -VariableHashtable @{
                Name = 'Name'
                IsSecret = $True
            }} | Should -Throw
        }

        It 'Should throw if VariableHashtable is used and not correct, Wrong keys' {
            {New-ADOPSVariableGroup -Project "myproject" -VariableGroupName "mygroup" -VariableHashtable @{
                WrongName = 'Name'
                IsSecret = $True
                Value = 'Value'
            }} | Should -Throw
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

        It 'Given VariableHashtable should construct a correct variables object, Single variable' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $Body
            }
            
            $r = New-ADOPSVariableGroup -Project "myproject" -VariableGroupName "mygroup" -VariableHashtable @{
                Name = 'VariableName'
                IsSecret = $True
                Value = 'Value'
            } | ConvertFrom-Json
            
            $r.variables.VariableName.value | Should -Be 'Value'
        }

        
        It 'Given VariableHashtable should construct a correct variables object, Multi variable' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $Body
            }
            
            $r = New-ADOPSVariableGroup -Project "myproject" -VariableGroupName "mygroup" -VariableHashtable @{
                Name = 'VariableName1'
                IsSecret = $True
                Value = 'Value1'
            }, @{
                Name = 'VariableName2'
                IsSecret = $True
                Value = 'Value2'
            } | ConvertFrom-Json
            
            $r.variables.VariableName1.value | Should -Be 'Value1'
            $r.variables.VariableName2.value | Should -Be 'Value2'
        }
    }
}
