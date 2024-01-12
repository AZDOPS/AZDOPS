param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'Get-ADOPSConnection' {
    # Since this function is simple and stupid id doesn't need parameter tests..
    Context 'Functionality' {
        BeforeAll {
            Mock -CommandName GetADOPSConfigFile -ModuleName ADOPS -MockWith {
                '{"Default":{"TenantId":"3328b76d-fc8e-43e9-9ce4-71ff86577d05","Identity":"dummy.user@mail.address","Organization":"ConnectedOrg"}}' | ConvertFrom-Json -AsHashtable
            }
        }

        It 'Command should exist' {
            $CmdExists  = Get-Command Get-ADOPSConnection -Module ADOPS -ErrorAction SilentlyContinue
            $CmdExists | Should -Not -BeNullOrEmpty
        }

        It 'If a connection is done it should return the name of the organization' {
            $Actual = Get-ADOPSConnection
            $Actual['Organization'] | Should -Be 'ConnectedOrg'
        }

        It 'If a connection is done it should return TennantId' {
            $Actual = Get-ADOPSConnection
            $Actual['TenantId'] | Should -Be '3328b76d-fc8e-43e9-9ce4-71ff86577d05'
        }

        It 'If a connection is done it should return the name of the Identity' {
            $Actual = Get-ADOPSConnection
            $Actual['Identity'] | Should -Be 'dummy.user@mail.address'
        }

        It 'If no connection is made, return nothing' {
            Mock -CommandName GetADOPSConfigFile -ModuleName ADOPS -MockWith {
                '{"Default":{}}' | ConvertFrom-Json -AsHashtable
            }
            $Actual = Get-ADOPSConnection
            $Actual | Should -BeNullOrEmpty
        }
    }
}