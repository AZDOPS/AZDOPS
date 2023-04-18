param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'Get-ADOPSConnection' {
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
                        Default = $true
                    }
                )
            }
        }
    }

    Context 'Functionality' {
        it 'If no connection is done, call NewAzToken' {
            InModuleScope -ModuleName ADOPS {
                Remove-Variable -Name ADOPSCredentials -Scope Script -ErrorAction SilentlyContinue
            }
            $null = Get-ADOPSConnection
            Should -Invoke -CommandName NewAzToken -Times 1 -ModuleName ADOPS
        }

        It 'Should return existing connection' {
            InModuleScope -ModuleName ADOPS {
                $script:ADOPSCredentials = @(
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
                      Default = $true
                    }
                )
            }

            # Parenthesis and typecasting to prevent unwrapping of array...
            ([array](Get-ADOPSConnection))[0].Organization | Should -Be 'Org1'
        }

        it 'Should throw id no token and NewAzToken fails' {
            InModuleScope -ModuleName ADOPS {
                Remove-Variable -Name ADOPSCredentials -Scope Script -ErrorAction SilentlyContinue
                Mock -CommandName NewAzToken -ModuleName ADOPS -MockWith { throw }
            }

            {Get-ADOPSConnection} | Should -Throw -ExpectedMessage 'No usable ADOPS credentials found. Use Connect-AzAccount or az login to connect.'
        }
    }
}

