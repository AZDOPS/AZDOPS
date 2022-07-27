Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot\..\Source\ADOPS -Force

BeforeAll {
    InModuleScope -ModuleName 'ADOPS' {
        Remove-Variable ADOPSCredentials -Scope 'Script' -ErrorAction SilentlyContinue
    }
}

Describe 'Creating connection variable' {
    Context 'Initial connection, No previous connection created' {
        BeforeAll {
            $DummyUser = 'DummyUserName'
            $DummyPassword = 'DummyPassword'
            $DummyOrg = 'DummyOrg'

            Mock -CommandName InvokeADOPSRestMethod -MockWith {} -ModuleName ADOPS
            Connect-ADOPS -Username $DummyUser -PersonalAccessToken $DummyPassword -Organization $DummyOrg
        }

        It 'Should create a ADOPSCredentials variable' {
            InModuleScope -ModuleName 'ADOPS' {
                Get-Variable -Name 'ADOPSCredentials' -Scope 'Script' | Should -Not -BeNullOrEmpty
            }
        }
        It 'ADOPSCredentials variable Should be a hashtable' {
            InModuleScope -ModuleName 'ADOPS' {
                $script:ADOPSCredentials.GetType().Name | Should -Be 'hashtable'
            }
        }
        It 'Variable should contain one conenction' {
            InModuleScope -ModuleName 'ADOPS' {
                $script:ADOPSCredentials.Keys.Count | Should -Be 1
            }
        }
        It 'Should have set one default conenction' {
            InModuleScope -ModuleName 'ADOPS' {
                $r = $script:ADOPSCredentials.Keys | Where-Object {$ADOPSCredentials[$_].Default -eq $true}
                $r.Count | Should -Be 1 -Because 'If this is the first connection we create we should always set it as default'
            }
        }

        It 'Variable should be encrypted (PSCredential)' {
            InModuleScope -ModuleName 'ADOPS' {
                $r = $script:ADOPSCredentials.Keys | Where-Object {$ADOPSCredentials[$_].Default -eq $true}
                $res = $ADOPSCredentials[$r]
                $res.Credential| Should -BeOfType [pscredential]
            }
        }
        It 'Username should be set' {
            InModuleScope -ModuleName 'ADOPS' -Parameters @{'DummyUser' = $DummyUser} {
                $r = $script:ADOPSCredentials.Keys | Where-Object {$ADOPSCredentials[$_].Default -eq $true}
                $res = $ADOPSCredentials[$r]
                $res.Credential.UserName | Should -Be $DummyUser
            }
        }
        It 'Password should be set' {
            InModuleScope -ModuleName 'ADOPS' -Parameters @{'DummyPassword' = $DummyPassword} {
                $r = $script:ADOPSCredentials.Keys | Where-Object {$ADOPSCredentials[$_].Default -eq $true}
                $res = $ADOPSCredentials[$r]
                $res.Credential.GetNetworkCredential().Password| Should -Be $DummyPassword
            }
        }
        It 'AzDoOrganization should be set as key' {
            InModuleScope -ModuleName 'ADOPS' -Parameters @{'DummyOrg' = $DummyOrg} {
                $r = $script:ADOPSCredentials.Keys | Where-Object {$ADOPSCredentials[$_].Default -eq $true}
                $r | Should -Be $DummyOrg
            }
        }
        It 'Should have called mock' {
            Should -Invoke InvokeADOPSRestMethod -Exactly 1 -Scope Context -ModuleName ADOPS
        }
    }

    Context 'Adding a second connection, not setting default' {
        BeforeAll {
            $DummyUser = 'DummyUserName2'
            $DummyPassword = 'DummyPassword2'
            $DummyOrg = 'DummyOrg2'

            Mock -CommandName InvokeADOPSRestMethod -MockWith {} -ModuleName ADOPS
            Connect-ADOPS -Username $DummyUser -PersonalAccessToken $DummyPassword -Organization $DummyOrg
        }

        It 'Variable should contain two conenctions' {
            InModuleScope -ModuleName 'ADOPS' {
                $script:ADOPSCredentials.Keys.Count | Should -Be 2
            }
        }
        It 'Should add this connection to connection list' {
            InModuleScope -ModuleName 'ADOPS' -Parameters @{'DummyOrg' = $DummyOrg} {
                $script:ADOPSCredentials.Keys | Should -Contain $DummyOrg
            }
        }
        It 'Should have only have one default conenction' {
            InModuleScope -ModuleName 'ADOPS' {
                $r = $script:ADOPSCredentials.Keys | Where-Object {$ADOPSCredentials[$_].Default -eq $true}
                $r.Count | Should -Be 1
            }
        }
    }

    Context 'Adding a third connection, setting this as default' {
        BeforeAll {
            $DummyUser = 'DummyUserName3'
            $DummyPassword = 'DummyPassword3'
            $DummyOrg = 'DummyOrg3'

            Mock -CommandName InvokeADOPSRestMethod -MockWith {} -ModuleName ADOPS
            Connect-ADOPS -Username $DummyUser -PersonalAccessToken $DummyPassword -Organization $DummyOrg -Default
        }

        It 'Variable should contain three conenctions' {
            InModuleScope -ModuleName 'ADOPS' {
                $script:ADOPSCredentials.Keys.Count | Should -Be 3
            }
        }
        It 'Should add this connection to connection list' {
            InModuleScope -ModuleName 'ADOPS' -Parameters @{'DummyOrg' = $DummyOrg} {
                $script:ADOPSCredentials.Keys | Should -Contain $DummyOrg

            }
        }
        It 'Should have only have one default conenction' {
            InModuleScope -ModuleName 'ADOPS' {
                $r = $script:ADOPSCredentials.Keys | Where-Object {$ADOPSCredentials[$_].Default -eq $true}
                $r.Count | Should -Be 1
            }
        }
        It "Username of default connection should be set to $DummyUser" {
            InModuleScope -ModuleName 'ADOPS' -Parameters @{'DummyUser' = $DummyUser} {
                $r = $script:ADOPSCredentials.Keys | Where-Object {$ADOPSCredentials[$_].Default -eq $true}
                $res = $ADOPSCredentials[$r]
                $res.Credential.UserName | Should -Be $DummyUser
            }
        }
    }
}


Describe 'Verifying parameters' {
    BeforeAll {
        Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
        Import-Module $PSScriptRoot\..\Source\ADOPS -Force
    }
    It 'Should have parameter Username' {
        (Get-Command Connect-ADOPS).Parameters.Keys | Should -Contain 'Username'
    }
    It 'Username should be required' {
        (Get-Command Connect-ADOPS).Parameters['Username'].Attributes.Mandatory | Should -Be $true
    }

    It 'Should have parameter PersonalAccessToken' {
        (Get-Command Connect-ADOPS).Parameters.Keys | Should -Contain 'PersonalAccessToken'
    }
    It 'PersonalAccessToken should be required' {
        (Get-Command Connect-ADOPS).Parameters['PersonalAccessToken'].Attributes.Mandatory | Should -Be $true
    }

    It 'Should have parameter Organization' {
        (Get-Command Connect-ADOPS).Parameters.Keys | Should -Contain 'Organization'
    }
    It 'Organization should be required' {
        (Get-Command Connect-ADOPS).Parameters['Organization'].Attributes.Mandatory | Should -Be $true
    }

    It 'Should have parameter Default' {
        (Get-Command Connect-ADOPS).Parameters.Keys | Should -Contain 'Default'
    }
    It 'Default should be switch' {
        (Get-Command Connect-ADOPS).Parameters['Default'].SwitchParameter | Should -Be $true
    }
}

Describe 'Bugfixes' {
    Context '#47 - External variables' {
        it 'If a console variable is set it should not throw error' {
            # One of the variable checks lacked the script: prefix
            # If you had the same variable name set in console it errored out with "Cannot index into a null array."
            Mock -CommandName InvokeADOPSRestMethod -MockWith {} -ModuleName ADOPS
            $global:ADOPSCredentials = @{ MyOrg = 'Variable' }

            {Connect-ADOPS -Username 'DummyUser1' -PersonalAccessToken 'MyPatGoesHere' -Organization 'MyOrg'} | Should -Not -Throw
        }
        AfterAll {
            Remove-Variable -Name ADOPSCredentials -Scope Global
        }
    }
}

Describe 'Validating try catch.' {
    Context 'Connect-ADOPS' {
        it 'Should trow if InvokeADOPSRestMethod returns error.' {
            Mock -CommandName InvokeADOPSRestMethod -MockWith {return throw} -ModuleName ADOPS

            {Connect-ADOPS -Username 'DummyUser1' -PersonalAccessToken 'MyPatGoesHere' -Organization 'MyOrg'} | Should -Throw
        }
    }
}