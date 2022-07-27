BeforeDiscovery {
    . $PSScriptRoot\TestHelpers.ps1
    Initialize-TestSetup
}

InModuleScope -ModuleName ADOPS {
    Describe 'Remove-ADOPSVariableGroup tests' {
        Context 'Removing variable group' {
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
                    return ''
                } -ParameterFilter { $method -eq 'Delete' }
                Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                    return [pscustomobject]@{
                        'count' = 1
                        'value' = @(
                            @{
                                id                             = 1
                                type                           = 'Vsts'
                                name                           = 'DummyGroup'
                                description                    = 'DummyDescription'
                                createdBy                      = @{
                                    displayName = 'John Doe'
                                    id          = '56c92d19-2fe9-49f8-96b4-922a0fea0e68'
                                }
                                createdOn                      = '2022-02-22 17:21:25'
                                modifiedBy                     = @{
                                    displayName = 'John Doe'
                                    id          = '56c92d19-2fe9-49f8-96b4-922a0fea0e68'
                                }
                                modifiedOn                     = '2022-02-22 17:21:25'
                                isShared                       = $false
                                variableGroupProjectReferences = @(
                                    @{
                                        projectReference = ''
                                        name             = 'DummyGroup'
                                        description      = 'DummyDescription'
                                    }
                                )
                            }
                        )
                    }
                } -ParameterFilter { $method -eq 'Get' }
                Mock -CommandName Get-ADOPSProject -ModuleName ADOPS -MockWith {
                    return [pscustomobject]@{
                        id = (New-Guid).Guid
                    }
                }

                $OrganizationName = 'DummyOrg'
                $Project = 'DummyProject'
                $VariableGroupName = 'DummyGroup'
            }

            It 'uses InvokeADOPSRestMethod two times' {
                Remove-ADOPSVariableGroup -Project $Project -VariableGroupName $VariableGroupName

                Should -Invoke 'InvokeADOPSRestMethod' -ModuleName 'ADOPS' -Exactly -Times 2
            }
            It 'returns empty output after removing variable group' {
                Remove-ADOPSVariableGroup -Project $Project -VariableGroupName $VariableGroupName | Should -BeNullOrEmpty
            }
            It 'should not throw with mandatory parameters' {
                { Remove-ADOPSVariableGroup -Project $Project -VariableGroupName $VariableGroupName } | Should -Not -Throw
            }
            It 'should throw if VariableGroupName Name is invalid' {
                { Remove-ADOPSVariableGroup -Organization $OrganizationName -Project $Project -VariableGroupName 'MissingVariableGroupName'} | Should -Throw
            }
        }

        Context 'Parameters' {
            It 'Should have parameter Organization' {
                (Get-Command Remove-ADOPSVariableGroup).Parameters.Keys | Should -Contain 'Organization'
            }
            It 'Organization should not be required' {
                (Get-Command Remove-ADOPSVariableGroup).Parameters['Organization'].Attributes.Mandatory | Should -Be $false
            }
            It 'Should have parameter Project' {
                (Get-Command Remove-ADOPSVariableGroup).Parameters.Keys | Should -Contain 'Project'
            }
            It 'Project should be required' {
                (Get-Command Remove-ADOPSVariableGroup).Parameters['Project'].Attributes.Mandatory | Should -Be $true
            }
            It 'Should have parameter VariableGroupName' {
                (Get-Command Remove-ADOPSVariableGroup).Parameters.Keys | Should -Contain 'VariableGroupName'
            }
            It 'VariableGroupName should not be required' {
                (Get-Command Remove-ADOPSVariableGroup).Parameters['VariableGroupName'].Attributes.Mandatory | Should -Be $true
            }
        }
    }
}