param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'Get-ADOPSUsageData' {
    Context 'Parameters' {
        $TestCases = @(
            @{
                Name = 'Organization'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'ProjectVisibility'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'SelfHosted'
                Mandatory = $false
                Type = 'switch'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command Get-ADOPSUsageData | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }

    Context "Verifying request data" {
        BeforeAll {
            Mock InvokeADOPSRestMethod -ModuleName ADOPS {}
            Mock -CommandName GetADOPSHeader -ModuleName ADOPS -MockWith {
                @{
                    Header       = @{
                        'Authorization' = 'Basic Base64=='
                    }
                    Organization = 'DummyOrg'
                }
            } -ParameterFilter { $Organization -eq 'Organization' }
            Mock -CommandName GetADOPSHeader -ModuleName ADOPS -MockWith {
                @{
                    Header       = @{
                        'Authorization' = 'Basic Base64=='
                    }
                    Organization = 'DummyOrg'
                }
            }
        }

        It 'Should get organization from GetADOPSHeader when organization parameter is used' {
            Get-ADOPSUsageData -Organization 'Organization'
            Should -Invoke GetADOPSHeader -ModuleName ADOPS -ParameterFilter { $Organization -eq 'Organization' } -Times 1 -Exactly
        }
        
        It 'Should validate organization using GetADOPSHeader when organization parameter is not used' {
            Get-ADOPSUsageData
            Should -Invoke GetADOPSHeader -ModuleName ADOPS -ParameterFilter { $Organization -eq 'Organization' } -Times 0 -Exactly
            Should -Invoke GetADOPSHeader -ModuleName ADOPS -Times 1 -Exactly
        }

        It 'Verifying request uri, ProjectVisibility:Private, SelfHosted:true' {
            Mock InvokeADOPSRestMethod -ModuleName ADOPS {
                return $URI
            }

            $r = Get-ADOPSUsageData -ProjectVisibility Private -SelfHosted
            $r | Should -Be 'https://dev.azure.com/DummyOrg/_apis/distributedtask/resourceusage?parallelismTag=Private&poolIsHosted=false&includeRunningRequests=true'
        }

        It 'Verifying request uri, ProjectVisibility:Public, SelfHosted:false' {
            Mock InvokeADOPSRestMethod -ModuleName ADOPS {
                return $URI
            }

            $r = Get-ADOPSUsageData -ProjectVisibility Public
            $r | Should -Be 'https://dev.azure.com/DummyOrg/_apis/distributedtask/resourceusage?parallelismTag=Public&poolIsHosted=true&includeRunningRequests=true'
        }
        
        It 'Verifying request uri, no parameters' {
            Mock InvokeADOPSRestMethod -ModuleName ADOPS {
                return $URI
            }

            $r = Get-ADOPSUsageData
            $r | Should -Be 'https://dev.azure.com/DummyOrg/_apis/distributedtask/resourceusage?parallelismTag=Public&poolIsHosted=true&includeRunningRequests=true'
        }

        It 'Verifying method: Get' {
            Mock InvokeADOPSRestMethod -ModuleName ADOPS {
                return $Method
            }
            
            $r = Get-ADOPSUsageData
            $r | Should -Be 'Get'
        }
    }
}