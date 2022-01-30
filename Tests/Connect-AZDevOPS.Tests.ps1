Remove-Module AZDevops -Force -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot\..\Source\AZDevops -Force

InModuleScope -ModuleName AZDevOPS {
    BeforeAll {
        Remove-Variable AZDevOPSCredentials -ErrorAction SilentlyContinue

        $DummyUser = 'DummyUserName'
        $DummyPassword = 'DummyPassword'
        Connect-AZDevOPS -Username $DummyUser -PersonalAccessToken $DummyPassword
    }

    Describe 'Creating connection variable' {
        It 'Should create a AZDevOPSCredentials variable' {
            Get-Variable -Name 'AZDevOPSCredentials' -Scope 'Script' | Should -Not -BeNullOrEmpty
        }
        It 'Variable should be encrypted (PSCredential)' {
            $Script:AZDevOPSCredentials | Should -BeOfType [pscredential] -Because 'Encrypted at rest is better than not encrypted at all'
        }
        It 'Username should be set' {
            $Script:AZDevOPSCredentials.UserName | Should -Be $DummyUser
        }
        It 'Password should be set' {
            $Script:AZDevOPSCredentials.GetNetworkCredential().Password| Should -Be $DummyPassword
        }
    }

}

Describe 'Verifying parameters' {
    BeforeAll {
        $DummyUser = 'DummyUserName'
        $DummyPassword = 'DummyPassword'
    }

    Context 'Missing parameters' {
        It 'Username should be required' {
            (Get-Command Connect-AZDevOPS).Parameters.Username.Attributes.Mandatory | Should -Be $true
        }
        It 'PersonalAccessToken should be required' {
            (Get-Command Connect-AZDevOPS).Parameters.PersonalAccessToken.Attributes.Mandatory | Should -Be $true
        }
    }
}
