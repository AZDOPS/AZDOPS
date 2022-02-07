Remove-Module AZDevops -Force -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot\..\Source\AZDevops -Force

InModuleScope -ModuleName AZDevOPS {
    BeforeAll {
        $Script:AZDevOPSCredentials = @{
            'org1' = @{
                Credential='CredentialObject1'
                Default = $false
            }
            'org2' = @{
                Credential='GetAZDevOPSHeader'
                Default = $true
            }
        }
    }

    
    Describe 'GetAZDevOPSHeader' {
        Context 'Given no input, should return the default connection' {
            It 'Should return credential value of default organization, org2' {
                (GetAZDevOPSHeader) | Should -Be 'GetAZDevOPSHeader'
            }
        }
    }
        #     It 'Command should exist' {
    #         Get-Command GetAZDevOPSHeader | Should -Not -BeNullOrEmpty
    #     }
    #     It 'Should return a hashtable' {
    #         GetAZDevOPSHeader | Should -BeOfType [Hashtable]
    #     }
    #     It 'Authorization block should start with "basic"' {
    #         (GetAZDevOPSHeader).Authorization | Should -BeLike "basic*"
    #     }
    # }
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