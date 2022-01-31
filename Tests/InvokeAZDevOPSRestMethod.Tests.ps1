Remove-Module AZDevops -Force -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot\..\Source\AZDevops -Force


InModuleScope -ModuleName AZDevOPS {
    BeforeAll {
        $DummyUser = 'DummyUserName'
        $DummyPassword = 'DummyPassword'
        $DummyOrg = 'DummyOrg'
        Connect-AZDevOPS -Username $DummyUser -PersonalAccessToken $DummyPassword -Organization $DummyOrg
    }
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
                Mock -CommandName GetAZDevOPSHeader -MockWith {@{Authorization = 'MockedHeader'}} -ModuleName AZDevOPS
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
                $ResultPostObject.Headers.Authorization | Should -Be 'MockedHeader'
            }
            
        }
    }
}