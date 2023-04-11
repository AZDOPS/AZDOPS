param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'NewAzToken' {
    BeforeAll {
        InModuleScope -ModuleName ADOPS {
            Mock -CommandName Get-AzToken -MockWith {
                @{
                    Token = "token1"
                    ExpiresOn = "2099-01-01T00:00:01+00:00"
                    ResourceUrl = "499b84ac-1321-427f-aa17-267ca6975798"
                    Scopes = @(
                      ".default"
                    )
                }              
            }

            Mock -CommandName Invoke-RestMethod -MockWith {
                @{
                    displayName = "userName"
                    publicAlias = "19f8733b-1022-4388-b356-a54c630b6e22"
                    emailAddress = "userName@mail.address"
                    coreRevision = 123456789
                    timeStamp = "2099-01-01T01:01:01.1234567+02:00"
                    id = "19f8733b-1022-4388-b356-a54c630b6e22"
                    revision = 123456789
                    value = @(
                        @{
                        accountId = "b69b6ea4-b087-4904-8506-60bd2fcbfee3"
                        accountUri = "https://vssps.dev.azure.com:443/org1/"
                        accountName = "org1"
                        properties = ""
                        }
                        @{
                        accountId = "5d47c6f0-1ea7-4b83-bcf2-5057e61afb5a"
                        accountUri = "https://vssps.dev.azure.com:443/org2/"
                        accountName = "org2"
                        properties = ""
                        }
                    )
                }                  
            }
        }
    }

    Context '' {
        It '' {
            InModuleScope -ModuleName ADOPS {
                
            }
        }
    }
}