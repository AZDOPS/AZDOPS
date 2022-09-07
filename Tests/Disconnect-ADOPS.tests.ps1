param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'Disconnect-ADOPS' {
    Context 'Parameters' {
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

    Context 'Command tests' {
        BeforeAll {
            InModuleScope -ModuleName 'ADOPS' {
                $Script:ADOPSCredentials = @"
                {
                    "ADOPS1": {
                      "Credential": {
                        "UserName": "john.doe@domain.com",
                        "Password": "first"
                      },
                      "Default": true
                    },
                    "ADOPS2": {
                      "Credential": {
                        "UserName": "john.doe@domain.com",
                        "Password": "second"
                      },
                      "Default": false
                    },
                    "ADOPS3": {
                      "Credential": {
                        "UserName": "john.doe@domain.com",
                        "Password": "third"
                      },
                      "Default": false
                    }
                }
"@ | ConvertFrom-Json -AsHashtable
            }
        }

        
        It 'should throw when organization not specified if multiple connections' {
            InModuleScope -ModuleName 'ADOPS' {
                $Script:ADOPSCredentials.Count | Should -BeExactly 3

                { Disconnect-ADOPS } | Should -Throw
            
                $Script:ADOPSCredentials.Count | Should -BeExactly 3
            }
        }

        # Removes 1 of 3 connections
        It 'removes the credential for the specified organization' {
            InModuleScope -ModuleName 'ADOPS' {
                $Script:ADOPSCredentials['ADOPS2'] | Should -Not -BeNullOrEmpty
                $Script:ADOPSCredentials.Count | Should -BeExactly 3
                Disconnect-ADOPS -Organization ADOPS2
                $Script:ADOPSCredentials['ADOPS2'] | Should -BeNullOrEmpty
                $Script:ADOPSCredentials.Count | Should -BeExactly 2
            }
        }

        # Removes 2 of 3 connections
        It 'sets the credential of another organization to default if default is removed' {
            InModuleScope -ModuleName 'ADOPS' {
                $Script:ADOPSCredentials['ADOPS1'].Default | Should -BeTrue
                $Script:ADOPSCredentials['ADOPS3'].Default | Should -BeFalse
                Disconnect-ADOPS -Organization ADOPS1
                $Script:ADOPSCredentials['ADOPS3'].Default | Should -BeTrue
            }
        }

        # Removes 3 of 3 connections
        It 'removes the last connection without parameter when only one' {
            InModuleScope -ModuleName 'ADOPS' {
                $Script:ADOPSCredentials.Count | Should -BeExactly 1
                { Disconnect-ADOPS } | Should -Not -Throw
                $Script:ADOPSCredentials.Count | Should -BeExactly 0
            }
        }
    }

    Context 'Validate throw when no Connections.' {
        BeforeAll {
            InModuleScope -ModuleName 'ADOPS' {
                $Script:ADOPSCredentials = $null
            }
        }

        It 'should throw when no Connections is availiable' {
            InModuleScope -ModuleName 'ADOPS' {
                $Script:ADOPSCredentials.Count | Should -BeExactly 0
                { Disconnect-ADOPS } | Should -Throw
                $Script:ADOPSCredentials.Count | Should -BeExactly 0
            }
        }
    }
}

