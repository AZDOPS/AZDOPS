BeforeDiscovery {
    . $PSScriptRoot\TestHelpers.ps1
    Initialize-TestSetup
}

InModuleScope -ModuleName ADOPS {
    BeforeAll {
        $Script:ADOPSCredentials = @{
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


    Describe 'GetADOPSHeader' {
        Context 'Given no input, should return the default connection' {
            It 'Should return credential value of default organization, org2' {
                (GetADOPSHeader).Header.Authorization | Should -BeLike "basic*"
            }
            It 'Token should contain organization name' {
                (GetADOPSHeader).Organization | Should -Be 'org2'
            }
        }
        Context 'Given an organization as input, should return that organization' {
            It 'Should return credential value of default organization, org1' {
                (GetADOPSHeader -Organization 'org1').Header.Authorization | Should -BeLike "basic*"
            }
            It 'Token should contain organization name' {
                (GetADOPSHeader -Organization 'org1').Organization | Should -Be 'org1'
            }
        }
    }
}

Describe 'Verifying parameters' {
    It 'Should have parameter Organization' {
        InModuleScope -ModuleName 'ADOPS' {
            (Get-Command GetADOPSHeader).Parameters.Keys | Should -Contain 'Organization'
        }
    }
}