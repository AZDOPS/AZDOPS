Remove-Module AZDevops -Force -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot\..\Source\AZDevops -Force

InModuleScope -ModuleName AZDevOPS {
    BeforeAll {
        $Script:AZDevOPSCredentials = @{
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

    
    Describe 'GetAZDevOPSHeader' {
        Context 'Given no input, should return the default connection' {
            It 'Should return credential value of default organization, org2' {
                (GetAZDevOPSHeader).Header.Authorization | Should -BeLike "basic*"
            }
            It 'Token should contain organization name' {
                (GetAZDevOPSHeader).Organization | Should -Be 'org2'
            }
        }
        Context 'Given an organization as input, should return that organization' {
            It 'Should return credential value of default organization, org1' {
                (GetAZDevOPSHeader -Organization 'org1').Header.Authorization | Should -BeLike "basic*"
            }
            It 'Token should contain organization name' {
                (GetAZDevOPSHeader -Organization 'org1').Organization | Should -Be 'org1'
            }
        }
    }
}

Describe 'Verifying parameters' {
    BeforeAll {
        Remove-Module AZDevOPS -Force -ErrorAction SilentlyContinue
        Import-Module $PSScriptRoot\..\Source\AZDevOPS -Force
    }
    It 'Should have parameter Organization' {
        InModuleScope -ModuleName 'AZDevOPS' {
            (Get-Command GetAZDevOPSHeader).Parameters.Keys | Should -Contain 'Organization'
        }
    }
}