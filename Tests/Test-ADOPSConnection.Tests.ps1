param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'Test-ADOPSConnection' {
    Context 'Parameters' {
        $TestCases = @(
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases {
            Get-Command Test-ADOPSConnection | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }
    
    Context 'functionality' {
        BeforeAll {
            Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'DummyOrg' }
        }

        It 'Should return something' {
            Test-ADOPSConnection | Should -Be $true
        }

    }
}