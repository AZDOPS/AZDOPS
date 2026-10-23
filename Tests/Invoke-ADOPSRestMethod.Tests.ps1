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
            },
            @{
                Name = 'FullResponse'
                Mandatory = $false
                Type = 'switch'
            }

        )

        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command Invoke-ADOPSRestMethod | Should-HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }

    Context "Functionality" {
        BeforeAll {
            InModuleScope -ModuleName ADOPS {
                Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                    return $InvokeSplat
                }
            }
            
            Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith {
                return 'dummyOrg'
            }
        }

        it 'Method should default to "Get"' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $Method
            }

            Invoke-ADOPSRestMethod -Uri 'uri' | Should-Be 'Get'
        }

        it 'Method should be set' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $Method
            }

            Invoke-ADOPSRestMethod -Uri 'uri' -Method 'Post' | Should-Be 'Post'
        }

        it 'Uri should be set using full uri - dev.azure.com' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $Uri
            }

            Invoke-ADOPSRestMethod -Uri 'https://dev.azure.com/dummyUri' -Method 'Post' | Should-Be 'https://dev.azure.com/dummyUri'
        }

        it 'Uri should be set using full uri - visualstudio.com' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $Uri
            }
            
            Invoke-ADOPSRestMethod -Uri 'https://dummyOrg.visualstudio.com/dummyUri' -Method 'Post' | Should-Be 'https://dummyOrg.visualstudio.com/dummyUri'
        }

        it 'Uri should be set using partial uri' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $Uri
            }

            Invoke-ADOPSRestMethod -Uri 'dummyUri' -Method 'Post' | Should-Be 'https://dev.azure.com/dummyOrg/dummyUri'
        }

        it 'If a body is given, post should include body'  {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $Body
            }

            Invoke-ADOPSRestMethod -Uri 'uri' -body '{body}' | Should-Be '{body}'
        }

        It 'Returns the full response unchanged with FullResponse enabled' {
            InModuleScope -ModuleName ADOPS {
                $headers = [System.Collections.Generic.Dictionary[string, string[]]]::new()
                $headers.Add('x-ms-continuationtoken', @('first', 'second'))
                $script:expectedResponse = @{
                    Content = @{ value = @(@{ id = 1 }, @{ id = 2 }) }
                    Headers = $headers
                    StatusCode = 200
                }
                Mock InvokeADOPSRestMethod { $script:expectedResponse }

                $response = Invoke-ADOPSRestMethod -Uri 'uri' -FullResponse

                $response | Should-BeSame $script:expectedResponse
                $response.Keys.Count | Should-Be 3
                $response.Headers['x-ms-continuationtoken'].Count | Should-Be 2
                $response.Headers['x-ms-continuationtoken'][0] | Should-Be 'first'
                $response.Headers['x-ms-continuationtoken'][1] | Should-Be 'second'
                Should-Invoke InvokeADOPSRestMethod -Exactly 1 -ParameterFilter {
                    $FullResponse -and $Uri -eq 'https://dev.azure.com/dummyOrg/uri' -and $Method -eq 'Get'
                }
            }
        }

        It 'Preserves body-only output when FullResponse is <Enabled>' -ForEach @(
            @{ Enabled = 'omitted'; Parameters = @{} }
            @{ Enabled = 'false'; Parameters = @{ FullResponse = $false } }
        ) {
            InModuleScope -ModuleName ADOPS -Parameters @{ Parameters = $Parameters } {
                $script:expectedBody = @{ value = @('one', 'two') }
                Mock InvokeADOPSRestMethod { $script:expectedBody }

                $response = Invoke-ADOPSRestMethod -Uri 'uri' @Parameters

                $response | Should-BeSame $script:expectedBody
                Should-Invoke InvokeADOPSRestMethod -Exactly 1 -ParameterFilter {
                    -not $FullResponse -and -not $PesterBoundParameters.ContainsKey('FullResponse')
                }
            }
        }

        It 'Preserves positional arguments and explicit method/body with FullResponse' {
            Invoke-ADOPSRestMethod 'https://dev.azure.com/dummyOrg/_apis/test' 'Patch' '{"value":1}' -FullResponse

            Should-Invoke InvokeADOPSRestMethod -ModuleName ADOPS -Exactly 1 -ParameterFilter {
                $FullResponse -and $Method -eq 'Patch' -and $Body -eq '{"value":1}' -and
                $Uri -eq 'https://dev.azure.com/dummyOrg/_apis/test' -and
                $PesterBoundParameters.Count -eq 4
            }
        }

        It 'Does not forward an empty body with FullResponse' {
            Invoke-ADOPSRestMethod -Uri 'uri' -Body '' -FullResponse

            Should-Invoke InvokeADOPSRestMethod -ModuleName ADOPS -Exactly 1 -ParameterFilter {
                $FullResponse -and -not $PesterBoundParameters.ContainsKey('Body')
            }
        }

        It 'Propagates transport errors with FullResponse <Enabled>' -ForEach @(
            @{ Enabled = $true }
            @{ Enabled = $false }
        ) {
            Mock InvokeADOPSRestMethod -ModuleName ADOPS { throw 'Transport failed' }

            { Invoke-ADOPSRestMethod -Uri 'uri' -FullResponse:$Enabled } | Should-Throw -ExceptionMessage 'Transport failed'
        }
    }
}
