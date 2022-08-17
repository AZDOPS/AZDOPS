#Requires -Module @{ ModuleName = 'Pester'; ModuleVersion = '5.3.1' }

Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot\..\Source\ADOPS -Force

Describe 'Disconnect-ADOPS tests' {
    Context 'Verifying parameters' {
        BeforeAll {
            Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
            Import-Module $PSScriptRoot\..\Source\ADOPS -Force
        }
        
        $TestCases = @(
            @{
                Name = 'Organization'
                Mandatory = $false
                Type = 'string'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command Disconnect-ADOPS | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }

    InModuleScope -ModuleName 'ADOPS' {
        Context 'Command tests' {
            BeforeAll {
                $Organization1 = 'ADOPS1'
                $Organization2 = 'ADOPS2'
                $Organization3 = 'ADOPS3'
                $Script:ADOPSCredentials = @"
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
                $Script:ADOPSCredentials.Count | Should -BeExactly 3
                { Disconnect-ADOPS } | Should -Throw
                $Script:ADOPSCredentials.Count | Should -BeExactly 3
            }

            # Removes 1 of 3 connections
            It 'removes the credential for the specified organization' {
                $Script:ADOPSCredentials[$Organization2] | Should -Not -BeNullOrEmpty
                $Script:ADOPSCredentials.Count | Should -BeExactly 3
                Disconnect-ADOPS -Organization $Organization2
                $Script:ADOPSCredentials[$Organization2] | Should -BeNullOrEmpty
                $Script:ADOPSCredentials.Count | Should -BeExactly 2
            }

            # Removes 2 of 3 connections
            It 'sets the credential of another organization to default if default is removed' {
                $Script:ADOPSCredentials[$Organization1].Default | Should -BeTrue
                $Script:ADOPSCredentials[$Organization3].Default | Should -BeFalse
                Disconnect-ADOPS -Organization $Organization1
                $Script:ADOPSCredentials[$Organization3].Default | Should -BeTrue
            }

            # Removes 3 of 3 connections
            It 'removes the last connection without parameter when only one' {
                $Script:ADOPSCredentials.Count | Should -BeExactly 1
                { Disconnect-ADOPS } | Should -Not -Throw
                $Script:ADOPSCredentials.Count | Should -BeExactly 0
            }
        }

        Context 'Validate throw when no Connections.' {
            BeforeAll {
                $Script:ADOPSCredentials = $null
            }

            It 'should throw when no Connections is availiable' {
                $Script:ADOPSCredentials.Count | Should -BeExactly 0
                { Disconnect-ADOPS } | Should -Throw
                $Script:ADOPSCredentials.Count | Should -BeExactly 0
            }
        }
    }
}

