Remove-Module AZDevOPS -Force -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot\..\Source\AZDevOPS -Force

InModuleScope -ModuleName AZDevOPS {
    BeforeAll {        
        Remove-Variable AZDevOPSCredentials -ErrorAction SilentlyContinue
        
        $DummyUser = 'DummyUserName'
        $DummyPassword = 'DummyPassword'
        $DummyOrg = 'DummyOrg'
    }
    
    Describe 'Creating connection variable' {
        Context 'mocking stuff' {
            BeforeAll {
                Mock -CommandName InvokeAZDevOPSRestMethod -MockWith {} -ModuleName AZDevOPS
                Connect-AZDevOPS -Username $DummyUser -PersonalAccessToken $DummyPassword -Organization $DummyOrg
            }

            It 'Should create a AZDevOPSCredentials variable' {
                Get-Variable -Name 'AZDevOPSCredentials' -Scope 'Script' | Should -Not -BeNullOrEmpty
            }
            It 'Variable should be encrypted (PSCredential)' {
                $Script:AZDevOPSCredentials | Should -BeOfType [pscredential]
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
            It 'Should have called mock' {
                Should -Invoke InvokeAZDevOPSRestMethod -Exactly 1 -Scope Context -ModuleName AZDevOPS
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
}
