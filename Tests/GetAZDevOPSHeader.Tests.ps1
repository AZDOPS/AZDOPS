BeforeAll {
    $DummyUser = 'DummyUserName'
    $DummyPassword = 'DummyPassword'
    Connect-AZDevOPS -Username $DummyUser -PersonalAccessToken $DummyPassword
}

InModuleScope -ModuleName AZDevOPS {
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
        It 'Authorization block should contain base64 encoded username and password string' {
            (GetAZDevOPSHeader).Authorization | Should -BeLike "*RHVtbXlVc2VyTmFtZTpEdW1teVBhc3N3b3Jk"
        }
    }
}