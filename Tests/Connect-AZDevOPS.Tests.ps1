Remove-Module AZDevops -Force -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot\..\Source\AZDevops -Force

InModuleScope -ModuleName AZDevOPS {
    BeforeAll {
        Remove-Variable AZDevOPSCredentials -ErrorAction SilentlyContinue
        # Mock -CommandName InvokeAZDevOPSRestMethod -MockWith {Return 'mocked'} -ModuleName AZDevOPS

        $DummyUser = 'DummyUserName'
        $DummyPassword = 'DummyPassword'
        $DummyOrg = 'DummyOrg'
        Connect-AZDevOPS -Username $DummyUser -PersonalAccessToken $DummyPassword -Organization $DummyOrg
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
        It 'AzDoOrganization should be set' {
            $Script:AzDOOrganization | Should -Be $DummyOrg
        }
    }
}

Describe 'Verifying parameters' {
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
}
