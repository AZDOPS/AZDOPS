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
                Name = 'method'
                Mandatory = $false
                Type = 'Microsoft.PowerShell.Commands.WebRequestMethod'
            },
            @{
                Name = 'body'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'uri'
                Mandatory = $true
                Type = 'uri'
            },
            @{
                Name = 'Organization'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'ContentType'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'FullResponse'
                Mandatory = $false
                Type = 'switch'
            },
            @{
                Name = 'OutFile'
                Mandatory = $false
                Type = 'string'
            }
        )

        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command InvokeADOPSRestMethod | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
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
            InModuleScope -ModuleName ADOPS {
                $PostObject = @{
                    Uri = 'https://dev.microsoft.com/dummyorg/dummy/api/path?Querysting=stuff'
                    Method = 'Get'
                    Body = @{Dummy='value'} | ConvertTo-Json
                }

                $null = InvokeADOPSRestMethod @PostObject
                Should -Invoke GetADOPSHeader -ModuleName ADOPS -Exactly 1
                Should -Invoke Invoke-RestMethod  -ModuleName ADOPS -Exactly 1
            }
        }

        It 'Verify URI is set' {
            InModuleScope -ModuleName ADOPS {
                Mock -CommandName Invoke-RestMethod -MockWith {Return $Uri} -ModuleName ADOPS
                $PostObject = @{
                    Uri = 'https://dev.microsoft.com/dummyorg/dummy/api/path?Querysting=stuff'
                    Method = 'Get'
                    Body = @{Dummy='value'} | ConvertTo-Json
                }

                $ResultPostObject = InvokeADOPSRestMethod @PostObject
                $ResultPostObject| Should -Be $PostObject.Uri
            }
        }

        It 'Verify Method is set' {
            InModuleScope -ModuleName ADOPS {
                Mock -CommandName Invoke-RestMethod -MockWith {Return $Method} -ModuleName ADOPS

                $PostObject = @{
                    Uri = 'https://dev.microsoft.com/dummyorg/dummy/api/path?Querysting=stuff'
                    Method = 'Get'
                    Body = @{Dummy='value'} | ConvertTo-Json
                }

                $ResultPostObject = InvokeADOPSRestMethod @PostObject
                $ResultPostObject | Should -Be $PostObject.Method
            }
        }

        It 'Verify ContentType is set' {
            InModuleScope -ModuleName ADOPS {
                Mock -CommandName Invoke-RestMethod -MockWith {Return $ContentType} -ModuleName ADOPS

                $PostObject = @{
                    Uri = 'https://dev.microsoft.com/dummyorg/dummy/api/path?Querysting=stuff'
                    Method = 'Get'
                    Body = @{Dummy='value'} | ConvertTo-Json
                }

                $ResultPostObject = InvokeADOPSRestMethod @PostObject
                $ResultPostObject | Should -Be 'application/json'
            }
        }

        It 'Verify ContentType when parameter is used' {
            InModuleScope -ModuleName ADOPS {
                Mock -CommandName Invoke-RestMethod -MockWith {Return $ContentType} -ModuleName ADOPS

                $PostObject = @{
                    Uri = 'https://dev.microsoft.com/dummyorg/dummy/api/path?Querysting=stuff'
                    Method = 'Get'
                    Body = @{Dummy='value'} | ConvertTo-Json
                }

                $ResultPostObject = InvokeADOPSRestMethod @PostObject -ContentType 'application/json-patch+json'
                $ResultPostObject | Should -Be 'application/json-patch+json'
            }
        }

        It 'Verify Body is set' {
            InModuleScope -ModuleName ADOPS {
                Mock -CommandName Invoke-RestMethod -MockWith {Return $Body} -ModuleName ADOPS

                $PostObject = @{
                    Uri = 'https://dev.microsoft.com/dummyorg/dummy/api/path?Querysting=stuff'
                    Method = 'Get'
                    Body = @{Dummy='value'} | ConvertTo-Json
                }

                $ResultPostObject = InvokeADOPSRestMethod @PostObject
                $ResultPostObject | Should -Be $PostObject.Body
            }
        }

        It 'Verify Header is set' {
            InModuleScope -ModuleName ADOPS {
                Mock -CommandName Invoke-RestMethod -MockWith {Return $Headers.Authorization} -ModuleName ADOPS

                $PostObject = @{
                    Uri = 'https://dev.microsoft.com/dummyorg/dummy/api/path?Querysting=stuff'
                    Method = 'Get'
                    Body = @{Dummy='value'} | ConvertTo-Json
                }

                $ResultPostObject = InvokeADOPSRestMethod @PostObject
                $ResultPostObject | Should -Be 'Basic RHVtbXlVc2VyMjpEdW1teVBhc3N3b3JkMg=='
            }
        }

        Context 'Parameters includes -Organization' {
            It 'If organization is given, it should get call GetADOPSHeader with that organization name' {
                InModuleScope -ModuleName ADOPS {
                    $PostObject = @{
                        Uri = 'https://dev.microsoft.com/dummyorg/dummy/api/path?Querysting=stuff'
                        Method = 'Get'
                        Body = @{Dummy='value'} | ConvertTo-Json
                    }

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
        }

        Context 'Calling API' {
            It 'If we get a sign in window that should be treated as a failure' {
                InModuleScope -ModuleName ADOPS {
                    $PostObject = @{
                        Uri = 'https://dev.microsoft.com/dummyorg/dummy/api/path?Querysting=stuff'
                        Method = 'Get'
                        Body = @{Dummy='value'} | ConvertTo-Json
                    }

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
        }

        # TODO: Test is not working as expected. Needs to be revisisted.
        # Context 'Returning data' {
        #     It 'Switch FullResponse should return Content, Headers, StatusCode' {
        #         InModuleScope -ModuleName ADOPS {
        #             $PostObject = @{
        #                 Uri = 'https://dev.microsoft.com/dummyorg/dummy/api/path?Querysting=stuff'
        #                 Method = 'Get'
        #                 Body = @{Dummy='value'} | ConvertTo-Json
        #             }

        #             Mock -CommandName GetADOPSHeader -MockWith {
        #                 @{
        #                     Header = @{
        #                         "Authorization" = "Basic RHVtbXlVc2VyMjpEdW1teVBhc3N3b3JkMg=="
        #                     }
        #                     Organization = "org2"
        #                 }
        #             } -ModuleName ADOPS

        #             Mock -CommandName Invoke-RestMethod -ModuleName ADOPS -MockWith {
        #                 Set-Variable -Scope Script -Name $PesterBoundParameters.ResponseHeadersVariable -Value @{ 'X-Test' = 'Foo' }
        #                 Set-Variable -Scope Script -Name $PesterBoundParameters.StatusCodeVariable -Value 200
        #                 return @{foo = 'bar'}
        #             }

        #             $response = InvokeADOPSRestMethod @PostObject -FullResponse
        #             Should -Invoke Invoke-RestMethod -ModuleName ADOPS -Exactly 1
        #             Should -Invoke GetADOPSHeader -ModuleName ADOPS -Exactly 1

        #             $response.Content | Should -Not -BeNullOrEmpty
        #             $response.Headers | Should -Not -BeNullOrEmpty
        #             $response.StatusCode | Should -Not -BeNullOrEmpty
        #         }
        #     }
        # }
    }
}
