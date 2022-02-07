Remove-Module AZDevops -Force -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot\..\Source\AZDevops -Force


InModuleScope -ModuleName AZDevOPS {
    Describe 'InvokeAZDevOPSRestMethod' {
        BeforeAll {
            $PostObject = @{
                Uri = 'https://dev.microsoft.com/dummyorg/dummy/api/path?Querysting=stuff'
                Method = 'Get'
                Body = @{Dummy='value'} | ConvertTo-Json
            }
        }
        Context 'Parameters' {
            It 'Should have parameter method' {
                (Get-Command InvokeAZDevOPSRestMethod).Parameters.Keys | Should -Contain 'method'
            }
            It 'Should have parameter body' {
                (Get-Command InvokeAZDevOPSRestMethod).Parameters.Keys | Should -Contain 'body'
            }
            It 'Should have parameter uri' {
                (Get-Command InvokeAZDevOPSRestMethod).Parameters.Keys | Should -Contain 'uri'
            }
            It 'Should have parameter Organization' {
                (Get-Command InvokeAZDevOPSRestMethod).Parameters.Keys | Should -Contain 'Organization'
            }
            
            It 'Uri should be mandatory' {
                (Get-Command InvokeAZDevOPSRestMethod).Parameters['uri'].Attributes.Mandatory | Should -Be $true
            }
            It 'Uri should be of type URI' {
                (Get-Command InvokeAZDevOPSRestMethod).Parameters['uri'].ParameterType.Name | Should -Be 'URI'
            }
            It 'Method should be of type WebRequestMethod' {
                (Get-Command InvokeAZDevOPSRestMethod).Parameters['Method'].ParameterType.Name | Should -Be 'WebRequestMethod'
            }
        }
        Context 'Building webrequest call' {
            BeforeEach {
                Mock -CommandName GetAZDevOPSHeader -MockWith {
                    @{
                        Header = @{
                            "Authorization" = "Basic RHVtbXlVc2VyMjpEdW1teVBhc3N3b3JkMg=="
                        }
                        Organization = "org2"
                    }
                } -ModuleName AZDevOPS
                Mock -CommandName Invoke-RestMethod -MockWith {Return $InvokeSplat} -ModuleName AZDevOPS
            }
            It 'Should call GetAZDevOPSHeader' {
                $null = InvokeAZDevOPSRestMethod @PostObject
                Should -Invoke GetAZDevOPSHeader -ModuleName AZDevOPS -Exactly 1
                Should -Invoke Invoke-RestMethod  -ModuleName AZDevOPS -Exactly 1
            }

            It 'Verify URI is set' {
                $ResultPostObject = InvokeAZDevOPSRestMethod @PostObject
                $ResultPostObject.Uri | Should -Be $PostObject.Uri
            }
            It 'Verify Method is set' {
                $ResultPostObject = InvokeAZDevOPSRestMethod @PostObject
                $ResultPostObject.Method | Should -Be $PostObject.Method
            }
            It 'Verify ContentType is set' {
                $ResultPostObject = InvokeAZDevOPSRestMethod @PostObject
                $ResultPostObject.ContentType | Should -Be 'application/json'
            }
            It 'Verify Body is set' {
                $ResultPostObject = InvokeAZDevOPSRestMethod @PostObject
                $ResultPostObject.Body | Should -Be $PostObject.Body
            }
            It 'Verify Header is set' {
                $ResultPostObject = InvokeAZDevOPSRestMethod @PostObject
                $ResultPostObject.Headers.Authorization | Should -Be 'Basic RHVtbXlVc2VyMjpEdW1teVBhc3N3b3JkMg=='
            }

            Context 'Parameters includes -Organization' {
                It 'If organization is given, it should get call GetAZDevOpsHeader with that organization name' {
                    Mock -CommandName GetAZDevOPSHeader -MockWith {
                        @{
                            Header = @{
                                "Authorization" = "Basic RHVtbXlVc2VyMjpEdW1teVBhc3N3b3JkMg=="
                            }
                            Organization = "org1"
                        }
                    } -ModuleName AZDevOPS -ParameterFilter {$Organization -eq 'org1'}
                    Mock -CommandName Invoke-RestMethod -MockWith {Return $CallHeaders} -ModuleName AZDevOPS

                    $ResultPostObject = InvokeAZDevOPSRestMethod @PostObject -Organization 'org1'
                    $ResultPostObject.Organization | Should -Be 'org1'
                    Should -Invoke GetAZDevOPSHeader -ModuleName AZDevOPS -Exactly 1 -ParameterFilter {$Organization -eq 'org1'}
                }
            }

            Context 'Calling API' {
                It 'If we get a sign in window that should be treated as a failure' {
                    Mock -CommandName GetAZDevOPSHeader -MockWith {
                        @{
                            Header = @{
                                "Authorization" = "Basic RHVtbXlVc2VyMjpEdW1teVBhc3N3b3JkMg=="
                            }
                            Organization = "org2"
                        }
                    } -ModuleName AZDevOPS
                    Mock -CommandName Invoke-RestMethod -ModuleName AZDevOPS -MockWith {
                        return '<html lang="en-US">
                        <head><title>
                        
                                    Azure DevOps Services | Sign In
                        
                        </title><meta http-equiv="X-UA-Compatible" content="IE=11;&#32;IE=10;&#32;IE=9;&#32;IE=8" />
                            <link rel="SHORTCUT ICON" href="/favicon.ico"/>'
                    }
    
                    {InvokeAZDevOPSRestMethod @PostObject} | Should -Throw
                    Should -Invoke Invoke-RestMethod -ModuleName AZDevOPS -Exactly 1
                    Should -Invoke GetAZDevOPSHeader -ModuleName AZDevOPS -Exactly 1
                }
            }
        }
    }
}