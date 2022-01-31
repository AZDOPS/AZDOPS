Remove-Module AZDevops -Force -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot\..\Source\AZDevops -Force

InModuleScope -ModuleName AZDevOPS {
    BeforeAll {
        $Script:AZDevOPSCredentials = [pscredential]::new('DummyUser', (ConvertTo-SecureString -String 'DummyPassWord' -AsPlainText -Force))
    }
    Describe 'GetAZDevOPSHeader' {
        It 'Command should exist' {
            Get-Command GetAZDevOPSHeader | Should -Not -BeNullOrEmpty
        }
        It 'Should return a hashtable' {
            GetAZDevOPSHeader | Should -BeOfType [Hashtable]
        }
        It 'Authorization block should start with "basic"' {
            (GetAZDevOPSHeader).Authorization | Should -BeLike "basic*"
        }
    }
}