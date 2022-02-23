#Requires -Module @{ ModuleName = 'Pester'; ModuleVersion = '5.3.1' }

Remove-Module AZDOPS -Force -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot\..\Source\AZDOPS -Force

Describe 'Disconnect-AZDOPS tests' {
    InModuleScope -ModuleName 'AZDOPS' {
        Context 'Command tests' {
            BeforeAll {
                $Organization1 = 'azdops1'
                $Organization2 = 'azdops2'
                $Organization3 = 'azdops3'
                $Script:AZDOPSCredentials = @"
                {
                    "$Organization1": {
                      "Credential": {
                        "UserName": "john.doe@domain.com",
                        "Password": "first"
                      },
                      "Default": true
                    },
                    "$Organization2": {
                      "Credential": {
                        "UserName": "john.doe@domain.com",
                        "Password": "second"
                      },
                      "Default": false
                    },
                    "$Organization3": {
                      "Credential": {
                        "UserName": "john.doe@domain.com",
                        "Password": "third"
                      },
                      "Default": false
                    }
                }
"@ | ConvertFrom-Json -AsHashtable
            }

            It 'should throw when organization not specified if multiple connections' {
                $Script:AZDOPSCredentials.Count | Should -BeExactly 3
                { Disconnect-AZDOPS } | Should -Throw
                $Script:AZDOPSCredentials.Count | Should -BeExactly 3
            }

            # Removes 1 of 3 connections
            It 'removes the credential for the specified organization' {
                $Script:AZDOPSCredentials[$Organization2] | Should -Not -BeNullOrEmpty
                $Script:AZDOPSCredentials.Count | Should -BeExactly 3
                Disconnect-AZDOPS -Organization $Organization2
                $Script:AZDOPSCredentials[$Organization2] | Should -BeNullOrEmpty
                $Script:AZDOPSCredentials.Count | Should -BeExactly 2
            }

            # Removes 2 of 3 connections
            It 'sets the credential of another organization to default if default is removed' {
                $Script:AZDOPSCredentials[$Organization1].Default | Should -BeTrue
                $Script:AZDOPSCredentials[$Organization3].Default | Should -BeFalse
                Disconnect-AZDOPS -Organization $Organization1
                $Script:AZDOPSCredentials[$Organization3].Default | Should -BeTrue
            }

            # Removes 3 of 3 connections
            It 'removes the last connection without parameter when only one' {
                $Script:AZDOPSCredentials.Count | Should -BeExactly 1
                { Disconnect-AZDOPS } | Should -Not -Throw
                $Script:AZDOPSCredentials.Count | Should -BeExactly 0
            }
        }
    }

    Context 'Verifying parameters' {
        BeforeAll {
            Remove-Module AZDOPS -Force -ErrorAction SilentlyContinue
            Import-Module $PSScriptRoot\..\Source\AZDOPS -Force
        }
        
        It 'Should have the parameter Organization' {
            (Get-Command Disconnect-AZDOPS).Parameters.Keys | Should -Contain 'Organization'
        }
        It 'Organization should not be mandatory' {
            (Get-Command Disconnect-AZDOPS).Parameters['Organization'].Attributes.Mandatory | Should -Be $false
        }
    }
}

