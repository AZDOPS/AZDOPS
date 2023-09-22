param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'Get-ADOPSVariableGroup' {
    Context 'Parameters' {
        $TestCases = @(
            @{
                Name = 'Organization'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'Project'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'Name'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'Id'
                Mandatory = $false
                Type = 'int'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command Get-ADOPSVariableGroup | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }

    Context 'Functionality' {
        BeforeAll {
            Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'DummyOrg' }

            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {}
        }

        It 'Should not get organization from GetADOPSDefaultOrganization when organization parameter is used' {
            Get-ADOPSVariableGroup -Organization 'Organization' -Project 'DummyProj'
            Should -Invoke GetADOPSDefaultOrganization -ModuleName ADOPS -Times 0 -Exactly
        }
        
        It 'Should get organization using GetADOPSDefaultOrganization when organization parameter is not used' {
            Get-ADOPSVariableGroup -Project 'DummyProj'
            Should -Invoke GetADOPSDefaultOrganization -ModuleName ADOPS -Times 1 -Exactly
        }
        
        It 'Verify URI is set when no search parameter is given.' {
            Mock -CommandName InvokeADOPSRestMethod -MockWith { Return @{value = $Uri} } -ModuleName ADOPS

            $Actual = Get-ADOPSVariableGroup -Project 'DummyProj'
            $Actual | Should -Be 'https://dev.azure.com/DummyOrg/DummyProj/_apis/distributedtask/variablegroups?api-version=7.2-preview.2'
        }
        
        It 'Verify URI is set when name search parameter is given.' {
            Mock -CommandName InvokeADOPSRestMethod -MockWith { Return @{value = $Uri} } -ModuleName ADOPS

            $Actual = Get-ADOPSVariableGroup -Project 'DummyProj' -Name 'VariableGroupName'
            $Actual | Should -Be 'https://dev.azure.com/DummyOrg/DummyProj/_apis/distributedtask/variablegroups?groupName=VariableGroupName&api-version=7.2-preview.2'
        }
        
        It 'Verify Method is set.' {
            Mock -CommandName InvokeADOPSRestMethod -MockWith { Return @{value = $Method} } -ModuleName ADOPS

            $Actual = Get-ADOPSVariableGroup -Project 'DummyProj'
            $Actual | Should -Be 'Get'
        }

        It 'If Id is given, only return the correct result.' {
            Mock -CommandName InvokeADOPSRestMethod -MockWith { 
                $resultValue = '[{"variables":{"G1S1":{"value":"value1"},"G1S2":{"value":"value2"}},"id":8,"type":"Vsts","name":"VariableGroup1"},{"variables":{"G2S1":{"value":"value1"},"G2S2":{"value":"value2"}},"id":9,"type":"Vsts","name":"VariableGroup2"},{"variables":{"G3S1":{"value":"value1"},"G3S2":{"value":"value2"}},"id":10,"type":"Vsts","name":"VariableGroup3"}]' | ConvertFrom-Json
                Return @{value = $resultValue}
            } -ModuleName ADOPS

            $Actual = Get-ADOPSVariableGroup -Project 'DummyProj' -Id 8
            $Actual.Count | Should -Be 1
        }
    }
}
