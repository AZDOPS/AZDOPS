Remove-Module AZDOPS -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot\..\Source\AZDOPS


Describe 'Get-AZDOPSConnection' {
    Context 'Function tests' {
        It 'We have a function' {
            Get-Command Get-AZDOPSConnection -Module AZDOPS | Should -Not -BeNullOrEmpty
        }
    }

    Context 'Verifying returned values' {
        BeforeAll {
            InModuleScope -ModuleName AZDOPS -ScriptBlock {
                $Script:AZDOPSCredentials = @{
                    'org1' = @{
                        Credential = [pscredential]::new('DummyUser1',(ConvertTo-SecureString -String 'DummyPassword1' -AsPlainText -Force))
                        Default = $false
                    }
                    'org2' = @{
                        Credential = [pscredential]::new('DummyUser2',(ConvertTo-SecureString -String 'DummyPassword2' -AsPlainText -Force))
                        Default = $true
                    }
                }
            }
        }
        
        It 'Given we have two connections, both connections should be returned' {
            (Get-AZDOPSConnection).Count | Should -Be 2
        }

        It 'Verifying the first returned organization matches the set variable' {
            (Get-AZDOPSConnection)['org1'].Credential.Username | Should -Be 'DummyUser1'
        }
    }
}

