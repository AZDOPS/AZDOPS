Remove-Module AZDOPS -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot\..\Source\AZDOPS

InModuleScope -ModuleName AZDOPS {
    Describe 'Remove-AZDOPSVariableGroup tests' {
        Context 'Removing variable group' {
            BeforeAll {
                Mock -CommandName GetAZDOPSHeader -ModuleName AZDOPS -MockWith {
                    @{
                        Header       = @{
                            'Authorization' = 'Basic Base64=='
                        }
                        Organization = $OrganizationName
                    }
                } -ParameterFilter { $OrganizationName -eq 'Organization' }
                Mock -CommandName GetAZDOPSHeader -ModuleName AZDOPS -MockWith {
                    @{
                        Header       = @{
                            'Authorization' = 'Basic Base64=='
                        }
                        Organization = $OrganizationName
                    }
                }

                Mock -CommandName InvokeAZDOPSRestMethod -ModuleName AZDOPS -MockWith {
                    return ''
                } -ParameterFilter { $method -eq 'Delete' }
                Mock -CommandName InvokeAZDOPSRestMethod -ModuleName AZDOPS -MockWith {
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
                Mock -CommandName Get-AZDOPSProject -ModuleName AZDOPS -MockWith {
                    return [pscustomobject]@{
                        id = (New-Guid).Guid
                    }
                }

                $OrganizationName = 'DummyOrg'
                $ProjectName = 'DummyProject'
                $VariableGroupName = 'DummyGroup'
            }

            It 'uses InvokeAZDOPSRestMethod two times' {
                Remove-AZDOPSVariableGroup -ProjectName $ProjectName -VariableGroupName $VariableGroupName

                Should -Invoke 'InvokeAZDOPSRestMethod' -ModuleName 'AZDOPS' -Exactly -Times 2
            }
            It 'returns empty output after removing variable group' {
                Remove-AZDOPSVariableGroup -ProjectName $ProjectName -VariableGroupName $VariableGroupName | Should -BeNullOrEmpty
            }
            It 'should not throw with mandatory parameters' {
                { Remove-AZDOPSVariableGroup -ProjectName $ProjectName -VariableGroupName $VariableGroupName } | Should -Not -Throw
            }
        }

        Context 'Parameters' {
            It 'Should have parameter Organization' {
                (Get-Command Remove-AZDOPSVariableGroup).Parameters.Keys | Should -Contain 'Organization'
            }
            It 'Organization should not be required' {
                (Get-Command Remove-AZDOPSVariableGroup).Parameters['Organization'].Attributes.Mandatory | Should -Be $false
            }
            It 'Should have parameter ProjectName' {
                (Get-Command Remove-AZDOPSVariableGroup).Parameters.Keys | Should -Contain 'ProjectName'
            }
            It 'ProjectName should be required' {
                (Get-Command Remove-AZDOPSVariableGroup).Parameters['ProjectName'].Attributes.Mandatory | Should -Be $true
            }
            It 'Should have parameter VariableGroupName' {
                (Get-Command Remove-AZDOPSVariableGroup).Parameters.Keys | Should -Contain 'VariableGroupName'
            }
            It 'VariableGroupName should not be required' {
                (Get-Command Remove-AZDOPSVariableGroup).Parameters['VariableGroupName'].Attributes.Mandatory | Should -Be $true
            }
        }
    }
}