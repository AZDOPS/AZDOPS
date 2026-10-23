param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'InvokeADOPSRestMethod' {
    Context 'Parameters' {
        $TestCases = @(
            @{
                Name      = 'method'
                Mandatory = $false
                Type      = 'Microsoft.PowerShell.Commands.WebRequestMethod'
            },
            @{
                Name      = 'body'
                Mandatory = $false
                Type      = 'string'
            },
            @{
                Name      = 'uri'
                Mandatory = $true
                Type      = 'uri'
            },
            @{
                Name      = 'ContentType'
                Mandatory = $false
                Type      = 'string'
            },
            @{
                Name      = 'FullResponse'
                Mandatory = $false
                Type      = 'switch'
            },
            @{
                Name      = 'OutFile'
                Mandatory = $false
                Type      = 'string'
            }
        )

        It 'Should have parameter <_.Name>' -TestCases $TestCases {
            Get-Command InvokeADOPSRestMethod | Should-HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }

    Context 'Building webrequest call' {
        BeforeAll {
            Mock -CommandName NewAzToken -ModuleName ADOPS -MockWith {
                @{
                    'Token' = 'eyJ0eXAiOiLoremIpsum'
                    'Identity' = 'DummyUser'
                    'TenantId' = 'DummyTenant' 
                }
            }
            Mock -CommandName Invoke-RestMethod -MockWith { Return $InvokeSplat } -ModuleName ADOPS
        }

        It 'Verify URI is set' {
            InModuleScope -ModuleName ADOPS {
                Mock -CommandName Invoke-RestMethod -MockWith { Return $Uri } -ModuleName ADOPS
                $PostObject = @{
                    Uri    = 'https://dev.microsoft.com/dummyorg/dummy/api/path?Querysting=stuff'
                    Method = 'Get'
                    Body   = @{Dummy = 'value' } | ConvertTo-Json
                }

                $ResultPostObject = InvokeADOPSRestMethod @PostObject
                $ResultPostObject | Should-Be $PostObject.Uri
            }
        }

        It 'Verify Method is set' {
            InModuleScope -ModuleName ADOPS {
                Mock -CommandName Invoke-RestMethod -MockWith { Return $Method } -ModuleName ADOPS

                $PostObject = @{
                    Uri    = 'https://dev.microsoft.com/dummyorg/dummy/api/path?Querysting=stuff'
                    Method = 'Get'
                    Body   = @{Dummy = 'value' } | ConvertTo-Json
                }

                $ResultPostObject = InvokeADOPSRestMethod @PostObject
                $ResultPostObject | Should-Be $PostObject.Method
            }
        }

        It 'Verify ContentType is set' {
            InModuleScope -ModuleName ADOPS {
                Mock -CommandName Invoke-RestMethod -MockWith { Return $ContentType } -ModuleName ADOPS

                $PostObject = @{
                    Uri    = 'https://dev.microsoft.com/dummyorg/dummy/api/path?Querysting=stuff'
                    Method = 'Get'
                    Body   = @{Dummy = 'value' } | ConvertTo-Json
                }

                $ResultPostObject = InvokeADOPSRestMethod @PostObject
                $ResultPostObject | Should-Be 'application/json'
            }
        }

        It 'Verify ContentType when parameter is used' {
            InModuleScope -ModuleName ADOPS {
                Mock -CommandName Invoke-RestMethod -MockWith { Return $ContentType } -ModuleName ADOPS

                $PostObject = @{
                    Uri    = 'https://dev.microsoft.com/dummyorg/dummy/api/path?Querysting=stuff'
                    Method = 'Get'
                    Body   = @{Dummy = 'value' } | ConvertTo-Json
                }

                $ResultPostObject = InvokeADOPSRestMethod @PostObject -ContentType 'application/json-patch+json'
                $ResultPostObject | Should-Be 'application/json-patch+json'
            }
        }

        It 'Verify Body is set' {
            InModuleScope -ModuleName ADOPS {
                Mock -CommandName Invoke-RestMethod -MockWith { Return $Body } -ModuleName ADOPS

                $PostObject = @{
                    Uri    = 'https://dev.microsoft.com/dummyorg/dummy/api/path?Querysting=stuff'
                    Method = 'Get'
                    Body   = @{Dummy = 'value' } | ConvertTo-Json
                }

                $ResultPostObject = InvokeADOPSRestMethod @PostObject
                $ResultPostObject | Should-Be $PostObject.Body
            }
        }

        It 'Verify Header is set' {
            InModuleScope -ModuleName ADOPS {
                Mock -CommandName Invoke-RestMethod -MockWith { Return $Headers.Authorization } -ModuleName ADOPS

                $PostObject = @{
                    Uri    = 'https://dev.microsoft.com/dummyorg/dummy/api/path?Querysting=stuff'
                    Method = 'Get'
                    Body   = @{Dummy = 'value' } | ConvertTo-Json
                }

                $ResultPostObject = InvokeADOPSRestMethod @PostObject
                $ResultPostObject | Should-Be 'Bearer eyJ0eXAiOiLoremIpsum'
            }
        }

        Context 'Calling API' {
            It 'If we get a sign in window that should be treated as a failure' {
                InModuleScope -ModuleName ADOPS {
                    $PostObject = @{
                        Uri    = 'https://dev.microsoft.com/dummyorg/dummy/api/path?Querysting=stuff'
                        Method = 'Get'
                        Body   = @{Dummy = 'value' } | ConvertTo-Json
                    }

                    Mock -CommandName Invoke-RestMethod -ModuleName ADOPS -MockWith {
                        return '<html lang="en-US">
                        <head><title>

                                    Azure DevOps Services | Sign In

                        </title><meta http-equiv="X-UA-Compatible" content="IE=11;&#32;IE=10;&#32;IE=9;&#32;IE=8" />
                            <link rel="SHORTCUT ICON" href="/favicon.ico"/>'
                    }

                    { InvokeADOPSRestMethod @PostObject } | Should-Throw
                    Should-Invoke Invoke-RestMethod -ModuleName ADOPS -Exactly 1
                }
            }
        }

        Context 'Returning data' {
            It 'Captures response headers and status only when FullResponse is enabled' {
                InModuleScope -ModuleName ADOPS {
                    Mock Invoke-RestMethod { @{ value = 'body' } }

                    InvokeADOPSRestMethod -Uri 'https://dev.azure.com/org/_apis/test' -Method Get -FullResponse

                    Should-Invoke Invoke-RestMethod -Exactly 1 -ParameterFilter {
                        $ResponseHeadersVariable -eq 'ResponseHeaders' -and
                        $StatusCodeVariable -eq 'ResponseStatusCode'
                    }
                }
            }

            It 'Returns the body without response capture when explicit false is <ExplicitFalse>' -ForEach @(
                @{ ExplicitFalse = $true }
                @{ ExplicitFalse = $false }
            ) {
                InModuleScope -ModuleName ADOPS -Parameters @{ ExplicitFalse = $ExplicitFalse } {
                    $script:expectedBody = @{ value = @('first', 'second') }
                    Mock Invoke-RestMethod { $script:expectedBody }
                    $parameters = @{}
                    if ($ExplicitFalse) {
                        $parameters.FullResponse = $false
                    }

                    $response = InvokeADOPSRestMethod -Uri 'https://dev.azure.com/org/_apis/test' -Method Get @parameters

                    $response | Should-BeSame $script:expectedBody
                    Should-Invoke Invoke-RestMethod -Exactly 1 -ParameterFilter {
                        -not $PesterBoundParameters.ContainsKey('ResponseHeadersVariable') -and
                        -not $PesterBoundParameters.ContainsKey('StatusCodeVariable')
                    }
                }
            }

            It 'Rejects a sign-in page with FullResponse enabled' {
                InModuleScope -ModuleName ADOPS {
                    Mock Invoke-RestMethod { 'Azure DevOps Services | Sign In' }

                    { InvokeADOPSRestMethod -Uri 'https://dev.azure.com/org/_apis/test' -Method Get -FullResponse } |
                        Should-Throw -ExceptionMessage '*Please login using Connect-ADOPS*'
                }
            }
        }
    }
}

Describe 'InvokeADOPSRestMethod native response capture' {
    BeforeEach {
        $script:listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Loopback, 0)
        $script:listener.Start()
        $script:localUri = "http://127.0.0.1:$($script:listener.LocalEndpoint.Port)"
        $script:server = Start-ThreadJob -ScriptBlock {
            $httpListener = $using:listener
            $client = $null
            try {
                $client = $httpListener.AcceptTcpClient()
                $stream = $client.GetStream()
                $stream.ReadTimeout = 10000
                $reader = [System.IO.StreamReader]::new($stream)
                $request = $reader.ReadLine()
                while (($line = $reader.ReadLine()) -ne '') {
                    if ($null -eq $line) {
                        throw 'Loopback HTTP client disconnected before sending request headers.'
                    }
                }

                $status = '200 OK'
                $body = '{"value":[{"id":1},{"id":2}]}'
                switch (($request -split ' ')[1]) {
                    '/array' { $body = '[{"id":1},{"id":2}]' }
                    '/empty' { $status = '204 No Content'; $body = '' }
                    '/error' { $status = '500 Internal Server Error'; $body = '{"error":"test failure"}' }
                }
                $response = "HTTP/1.1 $status`r`nContent-Type: application/json`r`nx-ms-continuationtoken: first`r`nx-ms-continuationtoken: second`r`nContent-Length: $([System.Text.Encoding]::UTF8.GetByteCount($body))`r`nConnection: close`r`n`r`n$body"
                $bytes = [System.Text.Encoding]::UTF8.GetBytes($response)
                $stream.Write($bytes, 0, $bytes.Length)
                $stream.Flush()
            }
            finally {
                if ($client) {
                    $client.Dispose()
                }
                $httpListener.Stop()
            }
        }
    }

    AfterEach {
        $script:listener.Stop()
        try {
            $completed = $script:server | Wait-Job -Timeout 10
            if (-not $completed) {
                throw 'Loopback HTTP fixture did not finish.'
            }
            $script:server | Receive-Job -ErrorAction Stop
            $script:server.State | Should-Be 'Completed'
        }
        finally {
            $script:server | Remove-Job -Force
        }
    }

    It 'Returns an object body, numeric status, and unflattened continuation headers' {
        InModuleScope -ModuleName ADOPS -Parameters @{ LocalUri = $script:localUri } {
            $response = InvokeADOPSRestMethod -Uri "$LocalUri/object" -Method Get -Token 'test-token' -FullResponse

            $response.GetType().FullName | Should-Be 'System.Collections.Hashtable'
            $response.Keys.Count | Should-Be 3
            $response.Content.value.Count | Should-Be 2
            $response.Content.value[0].id | Should-Be 1
            $response.StatusCode | Should-Be 200
            ($response.StatusCode -is [int]) | Should-BeTrue
            ($response.Headers -is [System.Collections.IDictionary]) | Should-BeTrue
            $response.Headers['x-ms-continuationtoken'].Count | Should-Be 2
            $response.Headers['x-ms-continuationtoken'][0] | Should-Be 'first'
            $response.Headers['x-ms-continuationtoken'][1] | Should-Be 'second'
        }
    }

    It 'Keeps a top-level array inside Content' {
        InModuleScope -ModuleName ADOPS -Parameters @{ LocalUri = $script:localUri } {
            $responses = @(InvokeADOPSRestMethod -Uri "$LocalUri/array" -Method Get -Token 'test-token' -FullResponse)

            $responses.Count | Should-Be 1
            $responses[0].Content.Count | Should-Be 2
            $responses[0].Content[1].id | Should-Be 2
        }
    }

    It 'Returns headers and status for a 204 response with empty Content' {
        InModuleScope -ModuleName ADOPS -Parameters @{ LocalUri = $script:localUri } {
            $response = InvokeADOPSRestMethod -Uri "$LocalUri/empty" -Method Get -Token 'test-token' -FullResponse

            $response.ContainsKey('Content') | Should-BeTrue
            [string]::IsNullOrEmpty($response.Content) | Should-BeTrue
            $response.StatusCode | Should-Be 204
            $response.Headers['x-ms-continuationtoken'].Count | Should-Be 2
        }
    }

    It 'Propagates an HTTP error instead of returning a success envelope' {
        InModuleScope -ModuleName ADOPS -Parameters @{ LocalUri = $script:localUri } {
            { InvokeADOPSRestMethod -Uri "$LocalUri/error" -Method Get -Token 'test-token' -FullResponse } |
                Should-Throw -ExceptionType ([Microsoft.PowerShell.Commands.HttpResponseException])
        }
    }
}
