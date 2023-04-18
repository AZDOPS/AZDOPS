param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'NewAzToken' {
    BeforeDiscovery {
        $TokenProperties = 'Organization', 'OauthToken', 'UserContext', 'Default'
    }
    
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
        }
    }

    Context 'Get tokens - two orgs' {
        BeforeAll {
            InModuleScope -ModuleName ADOPS {    
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

        It 'Output should be array, two organizations' {
            InModuleScope -ModuleName ADOPS {
                (NewAzToken).Count | Should -Be 2
            }
        }

        It 'No default org should be set' {
            $actual = NewAzToken
            $actual[0].Default | Should -BeFalse
            $actual[1].Default | Should -BeFalse
        }

        It 'Verifying other properties, org1, <_>' -TestCases $TokenProperties {
            $actual = NewAzToken
            $actual[0].Keys | Should -Contain $_
        } 

        It 'Verifying other properties, org2, <_>' -TestCases $TokenProperties {
            $actual = NewAzToken
            $actual[1].Keys | Should -Contain $_
        } 
    }

    Context 'Get tokens - one org' {
        BeforeAll {
            InModuleScope -ModuleName ADOPS {    
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
                        )
                    }                  
                }
            }
        }
        
        
        It 'Output should be array, one organization' {
            InModuleScope -ModuleName ADOPS {
                (NewAzToken).Count | Should -Be 1
            }
        }

        It 'Default org should be set' {
            $actual = NewAzToken
            $actual[0].Default | Should -BeTrue
        }

        It 'Verifying other properties, <_>' -TestCases $TokenProperties {
            $actual = NewAzToken
            $actual[0].Keys | Should -Contain $_
        } 
    }
}