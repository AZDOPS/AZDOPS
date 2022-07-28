BeforeDiscovery {
    . $PSScriptRoot\TestHelpers.ps1
    Initialize-TestSetup
}


InModuleScope -ModuleName ADOPS {
    Describe 'InvokeADOPSRestMethod' {
        BeforeAll {
            $PostObject = @{
                Uri = 'https://dev.microsoft.com/dummyorg/dummy/api/path?Querysting=stuff'
                Method = 'Get'
                Body = @{Dummy='value'} | ConvertTo-Json
            }
        }
        Context 'Parameter validation' {
            It 'Has parameter <_.Name>' -TestCases @(
                @{ Name = 'Method'; Type = [Microsoft.PowerShell.Commands.WebRequestMethod] }
                @{ Name = 'Body'; }
                @{ Name = 'Uri'; Mandatory = $true; Type = [URI] }
                @{ Name = 'Organization' }
                @{ Name = 'ContentType' }
                @{ Name = 'FullResponse'; Type = [switch] }
            ) {
                Get-Command -Name InvokeADOPSRestMethod | Should -HaveParameterStrict $Name -Mandatory:([bool]$Mandatory) -Type $Type
            }
        }

        Context 'Building webrequest call' {
            BeforeEach {
                Mock -CommandName GetADOPSHeader -MockWith {
                    @{
                        Header = @{
                            "Authorization" = "Basic RHVtbXlVc2VyMjpEdW1teVBhc3N3b3JkMg=="
                        }
                        Organization = "org2"
                    }
                } -ModuleName ADOPS
                Mock -CommandName Invoke-RestMethod -MockWith {Return $InvokeSplat} -ModuleName ADOPS
            }
            It 'Should call GetADOPSHeader' {
                $null = InvokeADOPSRestMethod @PostObject
                Should -Invoke GetADOPSHeader -ModuleName ADOPS -Exactly 1
                Should -Invoke Invoke-RestMethod  -ModuleName ADOPS -Exactly 1
            }

            It 'Verify URI is set' {
                $ResultPostObject = InvokeADOPSRestMethod @PostObject
                $ResultPostObject.Uri | Should -Be $PostObject.Uri
            }
            It 'Verify Method is set' {
                $ResultPostObject = InvokeADOPSRestMethod @PostObject
                $ResultPostObject.Method | Should -Be $PostObject.Method
            }
            It 'Verify ContentType is set' {
                $ResultPostObject = InvokeADOPSRestMethod @PostObject
                $ResultPostObject.ContentType | Should -Be 'application/json'
            }
            It 'Verify ContentType when parameter is used' {
                $ResultPostObject = InvokeADOPSRestMethod @PostObject -ContentType 'application/json-patch+json'
                $ResultPostObject.ContentType | Should -Be 'application/json-patch+json'
            }
            It 'Verify Body is set' {
                $ResultPostObject = InvokeADOPSRestMethod @PostObject
                $ResultPostObject.Body | Should -Be $PostObject.Body
            }
            It 'Verify Header is set' {
                $ResultPostObject = InvokeADOPSRestMethod @PostObject
                $ResultPostObject.Headers.Authorization | Should -Be 'Basic RHVtbXlVc2VyMjpEdW1teVBhc3N3b3JkMg=='
            }

            Context 'Parameters includes -Organization' {
                It 'If organization is given, it should get call GetADOPSHeader with that organization name' {
                    Mock -CommandName GetADOPSHeader -MockWith {
                        @{
                            Header = @{
                                "Authorization" = "Basic RHVtbXlVc2VyMjpEdW1teVBhc3N3b3JkMg=="
                            }
                            Organization = "org1"
                        }
                    } -ModuleName ADOPS -ParameterFilter {$Organization -eq 'org1'}
                    Mock -CommandName Invoke-RestMethod -MockWith {Return $CallHeaders} -ModuleName ADOPS

                    $ResultPostObject = InvokeADOPSRestMethod @PostObject -Organization 'org1'
                    $ResultPostObject.Organization | Should -Be 'org1'
                    Should -Invoke GetADOPSHeader -ModuleName ADOPS -Exactly 1 -ParameterFilter {$Organization -eq 'org1'}
                }
            }

            Context 'Calling API' {
                It 'If we get a sign in window that should be treated as a failure' {
                    Mock -CommandName GetADOPSHeader -MockWith {
                        @{
                            Header = @{
                                "Authorization" = "Basic RHVtbXlVc2VyMjpEdW1teVBhc3N3b3JkMg=="
                            }
                            Organization = "org2"
                        }
                    } -ModuleName ADOPS
                    Mock -CommandName Invoke-RestMethod -ModuleName ADOPS -MockWith {
                        return '<html lang="en-US">
                        <head><title>

                                    Azure DevOps Services | Sign In

                        </title><meta http-equiv="X-UA-Compatible" content="IE=11;&#32;IE=10;&#32;IE=9;&#32;IE=8" />
                            <link rel="SHORTCUT ICON" href="/favicon.ico"/>'
                    }

                    {InvokeADOPSRestMethod @PostObject} | Should -Throw
                    Should -Invoke Invoke-RestMethod -ModuleName ADOPS -Exactly 1
                    Should -Invoke GetADOPSHeader -ModuleName ADOPS -Exactly 1
                }
            }

            Context 'Returning data' {
                It 'Switch FullResponse should return Content, Headers, StatusCode' {
                    Mock -CommandName GetADOPSHeader -MockWith {
                        @{
                            Header = @{
                                "Authorization" = "Basic RHVtbXlVc2VyMjpEdW1teVBhc3N3b3JkMg=="
                            }
                            Organization = "org2"
                        }
                    } -ModuleName ADOPS
                    Mock -CommandName Invoke-RestMethod -ModuleName ADOPS -MockWith {
                        Set-Variable -Scope Script -Name $PesterBoundParameters.ResponseHeadersVariable -Value @{ 'X-Test' = 'Foo' }
                        Set-Variable -Scope Script -Name $PesterBoundParameters.StatusCodeVariable -Value 200
                        return @{foo = 'bar'}
                    }

                    $response = InvokeADOPSRestMethod @PostObject -FullResponse
                    Should -Invoke Invoke-RestMethod -ModuleName ADOPS -Exactly 1
                    Should -Invoke GetADOPSHeader -ModuleName ADOPS -Exactly 1

                    $response.Content | Should -Not -BeNullOrEmpty
                    $response.Headers | Should -Not -BeNullOrEmpty
                    $response.StatusCode | Should -Not -BeNullOrEmpty
                }
            }
        }
    }
}