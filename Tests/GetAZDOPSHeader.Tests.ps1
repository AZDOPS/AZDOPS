Remove-Module AZDOPS -Force -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot\..\Source\AZDOPS -Force

InModuleScope -ModuleName AZDOPS {
    BeforeAll {
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

    
    Describe 'GetAZDOPSHeader' {
        Context 'Given no input, should return the default connection' {
            It 'Should return credential value of default organization, org2' {
                (GetAZDOPSHeader).Header.Authorization | Should -BeLike "basic*"
            }
            It 'Token should contain organization name' {
                (GetAZDOPSHeader).Organization | Should -Be 'org2'
            }
        }
        Context 'Given an organization as input, should return that organization' {
            It 'Should return credential value of default organization, org1' {
                (GetAZDOPSHeader -Organization 'org1').Header.Authorization | Should -BeLike "basic*"
            }
            It 'Token should contain organization name' {
                (GetAZDOPSHeader -Organization 'org1').Organization | Should -Be 'org1'
            }
        }
    }
}

Describe 'Verifying parameters' {
    BeforeAll {
        Remove-Module AZDOPS -Force -ErrorAction SilentlyContinue
        Import-Module $PSScriptRoot\..\Source\AZDOPS -Force
    }
    It 'Should have parameter Organization' {
        InModuleScope -ModuleName 'AZDOPS' {
            (Get-Command GetAZDOPSHeader).Parameters.Keys | Should -Contain 'Organization'
        }
    }
}