param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'Disconnect-ADOPS' {
    Context 'Parameters' {
        It 'Should have no parameters' {
            (Get-Command GetADOPSDefaultOrganization).Parameters.GetEnumerator() | Where-Object {
                $_.Key -notin [System.Management.Automation.Cmdlet]::CommonParameters
            } | Should -BeNullOrEmpty
        }
    }

    Context 'Command tests' {
        BeforeAll {
            InModuleScope -ModuleName 'ADOPS' {
                Mock -ModuleName ADOPS NewADOPSConfigFile -MockWith { }
            }
        }
        
        It 'should not throw error' {
            InModuleScope -ModuleName 'ADOPS' {
                { Disconnect-ADOPS } | Should -Not -Throw
            }
        }
    }
}

