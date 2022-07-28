BeforeDiscovery {
    . $PSScriptRoot\TestHelpers.ps1
    Initialize-TestSetup
}

Describe 'GetADOPSHeader' {
    BeforeAll {
        InModuleScope -ModuleName ADOPS {
            $Script:ADOPSCredentials = @{
                'org1' = @{
                    Credential = [pscredential]::new('DummyUser1', (ConvertTo-SecureString -String 'DummyPassword1' -AsPlainText -Force))
                    Default    = $false
                }
                'org2' = @{
                    Credential = [pscredential]::new('DummyUser2', (ConvertTo-SecureString -String 'DummyPassword2' -AsPlainText -Force))
                    Default    = $true
                }
            }
        }
    }
    Context 'Parameter validation' {
        It 'Has parameter <_.Name>' -TestCases @(
            @{ Name = 'Organization' }
        ) {
            Get-Command -Name GetADOPSHeader | Should -HaveParameterStrict $Name -Mandatory:([bool]$Mandatory) -Type $Type
        }
    }
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
