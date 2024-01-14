param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'Invoke-ADOPSRestMethod' {
    BeforeAll {
        Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {}
    }

    Context "Parameters" {
        $TestCases = @(
            @{
                Name = 'Uri'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'Method'
                Mandatory = $false
                Type = 'Microsoft.PowerShell.Commands.WebRequestMethod'
            },
            @{
                Name = 'Body'
                Mandatory = $false
                Type = 'string'
            }

        )

        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command Invoke-ADOPSRestMethod | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }

    Context "Functionality" {
        BeforeAll {
            InModuleScope -ModuleName ADOPS {
                Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                    return $InvokeSplat
                }
            }
        }

        it 'Method should default to "Get"' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $Method
            }

            Invoke-ADOPSRestMethod -Uri 'uri' | Should -Be 'Get'
        }

        it 'Method should be set' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $Method
            }

            Invoke-ADOPSRestMethod -Uri 'uri' -Method 'Post' | Should -Be 'Post'
        }

        it 'Uri should be set using full uri - dev.azure.com' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $Uri
            }

            Invoke-ADOPSRestMethod -Uri 'https://dev.azure.com/dummyUri' -Method 'Post' | Should -Be 'https://dev.azure.com/dummyUri'
        }

        it 'Uri should be set using full uri - visualstudio.com' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $Uri
            }
            
            Invoke-ADOPSRestMethod -Uri 'https://dummyOrg.visualstudio.com/dummyUri' -Method 'Post' | Should -Be 'https://dummyOrg.visualstudio.com/dummyUri'
        }

        it 'Uri should be set using partial uri' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $Uri
            }
            Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith {
                return 'dummyOrg'
            }

            Invoke-ADOPSRestMethod -Uri 'dummyUri' -Method 'Post' | Should -Be 'https://dev.azure.com/dummyOrg/dummyUri'
        }

        it 'If a body is given, post should include body'  {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $Body
            }

            Invoke-ADOPSRestMethod -Uri 'uri' -body '{body}' | Should -Be '{body}'
        }
    }
}
