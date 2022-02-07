#Requires -Module @{ ModuleName = 'Pester'; ModuleVersion = '5.3.1' }

Remove-Module AZDevOPS -Force -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot\..\Source\AZDevOPS -Force


BeforeAll {
    InModuleScope -ModuleName 'AZDevOPS' {
        Remove-Variable AZDevOPSCredentials -Scope 'Script' -ErrorAction SilentlyContinue
    }
}

Describe 'Creating connection variable' {
    Context 'Initial connection, No previous connection created' {
        BeforeAll {
            $DummyUser = 'DummyUserName'
            $DummyPassword = 'DummyPassword'
            $DummyOrg = 'DummyOrg'

            Mock -CommandName InvokeAZDevOPSRestMethod -MockWith {} -ModuleName AZDevOPS
            Connect-AZDevOPS -Username $DummyUser -PersonalAccessToken $DummyPassword -Organization $DummyOrg
        }

        It 'Should create a AZDevOPSCredentials variable' {
            InModuleScope -ModuleName 'AZDevOPS' {
                Get-Variable -Name 'AZDevOPSCredentials' -Scope 'Script' | Should -Not -BeNullOrEmpty
            }
        }
        It 'AZDevOPSCredentials variable Should be a hashtable' {
            InModuleScope -ModuleName 'AZDevOPS' {
                $script:AZDevOPSCredentials.GetType().Name | Should -Be 'hashtable'
            }
        }
        It 'Variable should contain one conenction' {
            InModuleScope -ModuleName 'AZDevOPS' {
                $script:AZDevOPSCredentials.Keys.Count | Should -Be 1
            }
        }
        It 'Should have set one default conenction' {
            InModuleScope -ModuleName 'AZDevOPS' {
                $r = $script:AZDevOPSCredentials.Keys | Where-Object {$AZDevOPSCredentials[$_].Default -eq $true}
                $r.Count | Should -Be 1 -Because 'If this is the first connection we create we should always set it as default'
            }
        }

        It 'Variable should be encrypted (PSCredential)' {
            InModuleScope -ModuleName 'AZDevOPS' {
                $r = $script:AZDevOPSCredentials.Keys | Where-Object {$AZDevOPSCredentials[$_].Default -eq $true}
                $res = $AZDevOPSCredentials[$r]
                $res.Credential| Should -BeOfType [pscredential]
            }
        }
        It 'Username should be set' {
            InModuleScope -ModuleName 'AZDevOPS' -Parameters @{'DummyUser' = $DummyUser} {
                $r = $script:AZDevOPSCredentials.Keys | Where-Object {$AZDevOPSCredentials[$_].Default -eq $true}
                $res = $AZDevOPSCredentials[$r]
                $res.Credential.UserName | Should -Be $DummyUser
            }
        }
        It 'Password should be set' {
            InModuleScope -ModuleName 'AZDevOPS' -Parameters @{'DummyPassword' = $DummyPassword} {
                $r = $script:AZDevOPSCredentials.Keys | Where-Object {$AZDevOPSCredentials[$_].Default -eq $true}
                $res = $AZDevOPSCredentials[$r]
                $res.Credential.GetNetworkCredential().Password| Should -Be $DummyPassword
            }
        }
        It 'AzDoOrganization should be set as key' {
            InModuleScope -ModuleName 'AZDevOPS' -Parameters @{'DummyOrg' = $DummyOrg} {
                $r = $script:AZDevOPSCredentials.Keys | Where-Object {$AZDevOPSCredentials[$_].Default -eq $true}
                $r | Should -Be $DummyOrg
            }
        }
        It 'Should have called mock' {
            Should -Invoke InvokeAZDevOPSRestMethod -Exactly 1 -Scope Context -ModuleName AZDevOPS
        }
    }

    Context 'Adding a second connection, not setting default' {
        BeforeAll {
            $DummyUser = 'DummyUserName2'
            $DummyPassword = 'DummyPassword2'
            $DummyOrg = 'DummyOrg2'

            Mock -CommandName InvokeAZDevOPSRestMethod -MockWith {} -ModuleName AZDevOPS
            Connect-AZDevOPS -Username $DummyUser -PersonalAccessToken $DummyPassword -Organization $DummyOrg
        }

        It 'Variable should contain two conenctions' {
            InModuleScope -ModuleName 'AZDevOPS' {
                $script:AZDevOPSCredentials.Keys.Count | Should -Be 2
            }
        }
        It 'Should add this connection to connection list' {
            InModuleScope -ModuleName 'AZDevOPS' -Parameters @{'DummyOrg' = $DummyOrg} {
                $script:AZDevOPSCredentials.Keys | Should -Contain $DummyOrg
            }
        }
        It 'Should have only have one default conenction' {
            InModuleScope -ModuleName 'AZDevOPS' {
                $r = $script:AZDevOPSCredentials.Keys | Where-Object {$AZDevOPSCredentials[$_].Default -eq $true}
                $r.Count | Should -Be 1
            }
        }
    }

    Context 'Adding a third connection, setting this as default' {
        BeforeAll {
            $DummyUser = 'DummyUserName3'
            $DummyPassword = 'DummyPassword3'
            $DummyOrg = 'DummyOrg3'

            Mock -CommandName InvokeAZDevOPSRestMethod -MockWith {} -ModuleName AZDevOPS
            Connect-AZDevOPS -Username $DummyUser -PersonalAccessToken $DummyPassword -Organization $DummyOrg -Default
        }

        It 'Variable should contain three conenctions' {
            InModuleScope -ModuleName 'AZDevOPS' {
                $script:AZDevOPSCredentials.Keys.Count | Should -Be 3
            }
        }
        It 'Should add this connection to connection list' {
            InModuleScope -ModuleName 'AZDevOPS' -Parameters @{'DummyOrg' = $DummyOrg} {
                $script:AZDevOPSCredentials.Keys | Should -Contain $DummyOrg
            
            }
        }
        It 'Should have only have one default conenction' {
            InModuleScope -ModuleName 'AZDevOPS' {
                $r = $script:AZDevOPSCredentials.Keys | Where-Object {$AZDevOPSCredentials[$_].Default -eq $true}
                $r.Count | Should -Be 1
            }
        }
        It "Username of default connection should be set to $DummyUser" {
            InModuleScope -ModuleName 'AZDevOPS' -Parameters @{'DummyUser' = $DummyUser} {
                $r = $script:AZDevOPSCredentials.Keys | Where-Object {$AZDevOPSCredentials[$_].Default -eq $true}
                $res = $AZDevOPSCredentials[$r]
                $res.Credential.UserName | Should -Be $DummyUser
            }
        }
    }
}


Describe 'Verifying parameters' {
    BeforeAll {
        Remove-Module AZDevOPS -Force -ErrorAction SilentlyContinue
        Import-Module $PSScriptRoot\..\Source\AZDevOPS -Force
    }
    It 'Should have parameter Username' {
        (Get-Command Connect-AZDevOPS).Parameters.Keys | Should -Contain 'Username'
    }
    It 'Username should be required' {
        (Get-Command Connect-AZDevOPS).Parameters['Username'].Attributes.Mandatory | Should -Be $true
    }
    
    It 'Should have parameter PersonalAccessToken' {
        (Get-Command Connect-AZDevOPS).Parameters.Keys | Should -Contain 'PersonalAccessToken'
    }
    It 'PersonalAccessToken should be required' {
        (Get-Command Connect-AZDevOPS).Parameters['PersonalAccessToken'].Attributes.Mandatory | Should -Be $true
    }
    
    It 'Should have parameter Organization' {
        (Get-Command Connect-AZDevOPS).Parameters.Keys | Should -Contain 'Organization'
    }
    It 'Organization should be required' {
        (Get-Command Connect-AZDevOPS).Parameters['Organization'].Attributes.Mandatory | Should -Be $true
    }
    
    It 'Should have parameter Default' {
        (Get-Command Connect-AZDevOPS).Parameters.Keys | Should -Contain 'Default'
    }
    It 'Default should be switch' {
        (Get-Command Connect-AZDevOPS).Parameters['Default'].SwitchParameter | Should -Be $true
    }
}
