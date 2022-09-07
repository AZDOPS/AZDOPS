param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'Get-ADOPSConnection' {
    Context 'Parameters' {
        $TestCases = @(
            @{
                Name = 'Organization'
                Mandatory = $false
                Type = 'string'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command Get-ADOPSConnection | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }
    Context 'Verifying returned values' {
        BeforeAll {
            InModuleScope -ModuleName ADOPS -ScriptBlock {
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
        }
        
        It 'Given we have two connections, both connections should be returned' {
            (Get-ADOPSConnection).Count | Should -Be 2
        }
        It 'Should return one connection if Organization parameter is used.' {
            (Get-ADOPSConnection -Organization 'org1').Count | Should -Be 1
        }
        It 'Verifying the first returned organization matches the set variable' {
            (Get-ADOPSConnection)['org1'].Credential.Username | Should -Be 'DummyUser1'
        }
    }
}

