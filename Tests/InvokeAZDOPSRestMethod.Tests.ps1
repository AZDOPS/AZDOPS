Remove-Module AZDOPS -Force -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot\..\Source\AZDOPS -Force


InModuleScope -ModuleName AZDOPS {
    Describe 'InvokeAZDOPSRestMethod' {
        BeforeAll {
            $PostObject = @{
                Uri = 'https://dev.microsoft.com/dummyorg/dummy/api/path?Querysting=stuff'
                Method = 'Get'
                Body = @{Dummy='value'} | ConvertTo-Json
            }
        }
        Context 'Parameters' {
            It 'Should have parameter method' {
                (Get-Command InvokeAZDOPSRestMethod).Parameters.Keys | Should -Contain 'method'
            }
            It 'Should have parameter body' {
                (Get-Command InvokeAZDOPSRestMethod).Parameters.Keys | Should -Contain 'body'
            }
            It 'Should have parameter uri' {
                (Get-Command InvokeAZDOPSRestMethod).Parameters.Keys | Should -Contain 'uri'
            }
            It 'Should have parameter Organization' {
                (Get-Command InvokeAZDOPSRestMethod).Parameters.Keys | Should -Contain 'Organization'
            }
            It 'Should have parameter ContentType' {
                (Get-Command InvokeAZDOPSRestMethod).Parameters.Keys | Should -Contain 'ContentType'
            }
            
            It 'Uri should be mandatory' {
                (Get-Command InvokeAZDOPSRestMethod).Parameters['uri'].Attributes.Mandatory | Should -Be $true
            }
            It 'Uri should be of type URI' {
                (Get-Command InvokeAZDOPSRestMethod).Parameters['uri'].ParameterType.Name | Should -Be 'URI'
            }
            It 'Method should be of type WebRequestMethod' {
                (Get-Command InvokeAZDOPSRestMethod).Parameters['Method'].ParameterType.Name | Should -Be 'WebRequestMethod'
            }
        }
        Context 'Building webrequest call' {
            BeforeEach {
                Mock -CommandName GetAZDOPSHeader -MockWith {
                    @{
                        Header = @{
                            "Authorization" = "Basic RHVtbXlVc2VyMjpEdW1teVBhc3N3b3JkMg=="
                        }
                        Organization = "org2"
                    }
                } -ModuleName AZDOPS
                Mock -CommandName Invoke-RestMethod -MockWith {Return $InvokeSplat} -ModuleName AZDOPS
            }
            It 'Should call GetAZDOPSHeader' {
                $null = InvokeAZDOPSRestMethod @PostObject
                Should -Invoke GetAZDOPSHeader -ModuleName AZDOPS -Exactly 1
                Should -Invoke Invoke-RestMethod  -ModuleName AZDOPS -Exactly 1
            }

            It 'Verify URI is set' {
                $ResultPostObject = InvokeAZDOPSRestMethod @PostObject
                $ResultPostObject.Uri | Should -Be $PostObject.Uri
            }
            It 'Verify Method is set' {
                $ResultPostObject = InvokeAZDOPSRestMethod @PostObject
                $ResultPostObject.Method | Should -Be $PostObject.Method
            }
            It 'Verify ContentType is set' {
                $ResultPostObject = InvokeAZDOPSRestMethod @PostObject
                $ResultPostObject.ContentType | Should -Be 'application/json'
            }
            It 'Verify ContentType when parameter is used' {
                $ResultPostObject = InvokeAZDOPSRestMethod @PostObject -ContentType 'application/json-patch+json'
                $ResultPostObject.ContentType | Should -Be 'application/json-patch+json'
            }
            It 'Verify Body is set' {
                $ResultPostObject = InvokeAZDOPSRestMethod @PostObject
                $ResultPostObject.Body | Should -Be $PostObject.Body
            }
            It 'Verify Header is set' {
                $ResultPostObject = InvokeAZDOPSRestMethod @PostObject
                $ResultPostObject.Headers.Authorization | Should -Be 'Basic RHVtbXlVc2VyMjpEdW1teVBhc3N3b3JkMg=='
            }

            Context 'Parameters includes -Organization' {
                It 'If organization is given, it should get call GetAZDOPSHeader with that organization name' {
                    Mock -CommandName GetAZDOPSHeader -MockWith {
                        @{
                            Header = @{
                                "Authorization" = "Basic RHVtbXlVc2VyMjpEdW1teVBhc3N3b3JkMg=="
                            }
                            Organization = "org1"
                        }
                    } -ModuleName AZDOPS -ParameterFilter {$Organization -eq 'org1'}
                    Mock -CommandName Invoke-RestMethod -MockWith {Return $CallHeaders} -ModuleName AZDOPS

                    $ResultPostObject = InvokeAZDOPSRestMethod @PostObject -Organization 'org1'
                    $ResultPostObject.Organization | Should -Be 'org1'
                    Should -Invoke GetAZDOPSHeader -ModuleName AZDOPS -Exactly 1 -ParameterFilter {$Organization -eq 'org1'}
                }
            }

            Context 'Calling API' {
                It 'If we get a sign in window that should be treated as a failure' {
                    Mock -CommandName GetAZDOPSHeader -MockWith {
                        @{
                            Header = @{
                                "Authorization" = "Basic RHVtbXlVc2VyMjpEdW1teVBhc3N3b3JkMg=="
                            }
                            Organization = "org2"
                        }
                    } -ModuleName AZDOPS
                    Mock -CommandName Invoke-RestMethod -ModuleName AZDOPS -MockWith {
                        return '<html lang="en-US">
                        <head><title>
                        
                                    Azure DevOps Services | Sign In
                        
                        </title><meta http-equiv="X-UA-Compatible" content="IE=11;&#32;IE=10;&#32;IE=9;&#32;IE=8" />
                            <link rel="SHORTCUT ICON" href="/favicon.ico"/>'
                    }
    
                    {InvokeAZDOPSRestMethod @PostObject} | Should -Throw
                    Should -Invoke Invoke-RestMethod -ModuleName AZDOPS -Exactly 1
                    Should -Invoke GetAZDOPSHeader -ModuleName AZDOPS -Exactly 1
                }
            }
        }
    }
}