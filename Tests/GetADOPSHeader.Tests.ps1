param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'GetADOPSHeader' {
    BeforeAll {
        InModuleScope -ModuleName ADOPS {
            Mock -CommandName NewAzToken -ModuleName ADOPS -MockWith {
                @(
                    @{
                        Organization = "org1"
                        OauthToken = @{
                        Token = "connectionToken"
                        ExpiresOn = "2099-01-01T00:00:01+00:00"
                        ResourceUrl = "499b84ac-1321-427f-aa17-267ca6975798"
                        Scopes = @(
                            ".default"
                        )
                        }
                        UserContext = @{
                        displayName = "user.name"
                        publicAlias = "54b5d39f-f5a7-43a8-a832-b98f550f8af8"
                        emailAddress = "user.name@gmail.address"
                        coreRevision = 123456789
                        timeStamp = "2099-01-01T00:00:01.1234567+00:00"
                        id = "54b5d39f-f5a7-43a8-a832-b98f550f8af8"
                        revision = 123456789
                        }
                        Default = $false
                    }
                    @{
                        Organization = "org2"
                        OauthToken = @{
                        Token = "connectionToken"
                        ExpiresOn = "2099-01-01T00:00:01+00:00"
                        ResourceUrl = "499b84ac-1321-427f-aa17-267ca6975798"
                        Scopes = @(
                            ".default"
                        )
                        }
                        UserContext = @{
                        displayName = "bjorn.sundling"
                        publicAlias = "54b5d39f-f5a7-43a8-a832-b98f550f8af8"
                        emailAddress = "user.name@gmail.address"
                        coreRevision = 123456789
                        timeStamp = "2099-01-01T00:00:01.1234567+00:00"
                        id = "54b5d39f-f5a7-43a8-a832-b98f550f8af8"
                        revision = 123456789
                        }
                        Default = $false
                    }
                )
            }
        }
    }

    Context 'Parameters' {
        $TestCases = @(
            @{
                Name = 'Organization'
                Mandatory = $false
                Type = 'string'
            }
        )

        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command GetADOPSHeader | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }

    Context 'No existing token' {
        BeforeEach {
            InModuleScope -ModuleName ADOPS {
                Remove-Variable ADOPSCredentials -Scope Script -ErrorAction SilentlyContinue
            }
        }

        it 'Should run NewAzToken and create token' {
            InModuleScope -ModuleName ADOPS {
                $actual = try {GetADOPSHeader} catch {}
                Get-Variable ADOPSCredentials | Should -Not -BeNullOrEmpty
                Should -Invoke -CommandName NewAzToken -Times 1 -ModuleName ADOPS
            }
        }
        
        it 'If NewAzToken fails, should throw good error message' {
            InModuleScope -ModuleName ADOPS {
                Mock -CommandName NewAzToken -ModuleName ADOPS -MockWith {
                    Throw
                }

                {GetADOPSHeader}| Should -Throw -ExpectedMessage 'No usable ADOPS credentials found. Use Connect-AzAccount or az login to connect.'
            }
        }
    }

    Context 'Existing token, no default' {
        BeforeEach {
            InModuleScope -ModuleName ADOPS {
                Remove-Variable ADOPSCredentials -Scope Script -ErrorAction SilentlyContinue

                $Script:ADOPSCredentials = @(
                    @{
                        Organization = "org1"
                        OauthToken = @{
                        Token = "connectionToken1"
                        ExpiresOn = "2099-01-01T00:00:01+00:00"
                        ResourceUrl = "499b84ac-1321-427f-aa17-267ca6975798"
                        Scopes = @(
                            ".default"
                        )
                        }
                        UserContext = @{
                        displayName = "user.name"
                        publicAlias = "54b5d39f-f5a7-43a8-a832-b98f550f8af8"
                        emailAddress = "user.name@gmail.address"
                        coreRevision = 123456789
                        timeStamp = "2099-01-01T00:00:01.1234567+00:00"
                        id = "54b5d39f-f5a7-43a8-a832-b98f550f8af8"
                        revision = 123456789
                        }
                        Default = $false
                    }
                    @{
                        Organization = "org2"
                        OauthToken = @{
                        Token = "connectionToken2"
                        ExpiresOn = "2099-01-01T00:00:01+00:00"
                        ResourceUrl = "499b84ac-1321-427f-aa17-267ca6975798"
                        Scopes = @(
                            ".default"
                        )
                        }
                        UserContext = @{
                        displayName = "bjorn.sundling"
                        publicAlias = "54b5d39f-f5a7-43a8-a832-b98f550f8af8"
                        emailAddress = "user.name@gmail.address"
                        coreRevision = 123456789
                        timeStamp = "2099-01-01T00:00:01.1234567+00:00"
                        id = "54b5d39f-f5a7-43a8-a832-b98f550f8af8"
                        revision = 123456789
                        }
                        Default = $false
                    }
                )
            }
        }

        it 'Not giving Organization should throw clear error message' {
            InModuleScope -ModuleName ADOPS {
                {GetADOPSHeader}| Should -Throw -ExpectedMessage 'No default organization set. Please state organization, or use "Set-ADOPSConnection -DefaultOrganization $myOrg"'
            }
        }
        
        it 'Giving Organization should return corect organization in result' {
            InModuleScope -ModuleName ADOPS {
                (GetADOPSHeader -Organization org1)['Organization'] | Should -Be 'Org1'
            }
        }
        
        it 'Giving non existing Organization should throw' {
            InModuleScope -ModuleName ADOPS {
                {GetADOPSHeader -Organization org3}| Should -Throw
            }
        }
        
        it 'Output should contain bearer token' {
            InModuleScope -ModuleName ADOPS {
                (GetADOPSHeader -Organization org1)['Header'].Authorization | Should -Be 'Bearer connectionToken1' 
            }
        }
    }

    Context 'Existing token, default set' {
        BeforeEach {
            InModuleScope -ModuleName ADOPS {
                Remove-Variable ADOPSCredentials -Scope Script -ErrorAction SilentlyContinue

                $Script:ADOPSCredentials = @(
                    @{
                        Organization = "org1"
                        OauthToken = @{
                        Token = "connectionToken1"
                        ExpiresOn = "2099-01-01T00:00:01+00:00"
                        ResourceUrl = "499b84ac-1321-427f-aa17-267ca6975798"
                        Scopes = @(
                            ".default"
                        )
                        }
                        UserContext = @{
                        displayName = "user.name"
                        publicAlias = "54b5d39f-f5a7-43a8-a832-b98f550f8af8"
                        emailAddress = "user.name@gmail.address"
                        coreRevision = 123456789
                        timeStamp = "2099-01-01T00:00:01.1234567+00:00"
                        id = "54b5d39f-f5a7-43a8-a832-b98f550f8af8"
                        revision = 123456789
                        }
                        Default = $false
                    }
                    @{
                        Organization = "org2"
                        OauthToken = @{
                        Token = "connectionToken2"
                        ExpiresOn = "2099-01-01T00:00:01+00:00"
                        ResourceUrl = "499b84ac-1321-427f-aa17-267ca6975798"
                        Scopes = @(
                            ".default"
                        )
                        }
                        UserContext = @{
                        displayName = "bjorn.sundling"
                        publicAlias = "54b5d39f-f5a7-43a8-a832-b98f550f8af8"
                        emailAddress = "user.name@gmail.address"
                        coreRevision = 123456789
                        timeStamp = "2099-01-01T00:00:01.1234567+00:00"
                        id = "54b5d39f-f5a7-43a8-a832-b98f550f8af8"
                        revision = 123456789
                        }
                        Default = $true
                    }
                )
            }
        }
        
        it 'Not giving Organization should return default' {
            InModuleScope -ModuleName ADOPS {
                (GetADOPSHeader)['Organization'] | Should -Be 'Org2'
            }
        }
        
        it 'Giving Organization should return corect organization in result' {
            InModuleScope -ModuleName ADOPS {
                (GetADOPSHeader -Organization org1)['Organization'] | Should -Be 'Org1'
            }
        }
        
        it 'Giving non existing Organization should throw' {
            InModuleScope -ModuleName ADOPS {
                {GetADOPSHeader -Organization org3}| Should -Throw
            }
        }
        
        it 'Output should contain bearer token' {
            InModuleScope -ModuleName ADOPS {
                (GetADOPSHeader)['Header'].Authorization | Should -Be 'Bearer connectionToken2' 
            }
        }
    }

    Context 'Expired token' {
        BeforeEach {
            InModuleScope -ModuleName ADOPS {
                Remove-Variable ADOPSCredentials -Scope Script -ErrorAction SilentlyContinue

                $Script:ADOPSCredentials = @(
                    @{
                        Organization = "org1"
                        OauthToken = @{
                        Token = "connectionToken1"
                        ExpiresOn = "2001-01-01T00:00:01+00:00"
                        ResourceUrl = "499b84ac-1321-427f-aa17-267ca6975798"
                        Scopes = @(
                            ".default"
                        )
                        }
                        UserContext = @{
                        displayName = "user.name"
                        publicAlias = "54b5d39f-f5a7-43a8-a832-b98f550f8af8"
                        emailAddress = "user.name@gmail.address"
                        coreRevision = 123456789
                        timeStamp = "2099-01-01T00:00:01.1234567+00:00"
                        id = "54b5d39f-f5a7-43a8-a832-b98f550f8af8"
                        revision = 123456789
                        }
                        Default = $true
                    }
                )
            }
        }
        
        it 'Expired token should call NewAzToken 1 time to refresh' {
            InModuleScope -ModuleName ADOPS {
                $null = GetADOPSHeader
                Should -Invoke NewAzToken -Times 1
            }
        }
        
        it 'Refreshed token should be valid' {
            InModuleScope -ModuleName ADOPS {
                Mock -CommandName Write-Output -MockWith {
                    Return $r
                }
                ([DateTime]((GetADOPSHeader).OAuthToken.ExpiresOn)).Year | Should -Be '2099'
            }
        }
    }
}

