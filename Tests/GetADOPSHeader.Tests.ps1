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

    Context '' {
        it '' {
            InModuleScope -ModuleName ADOPS {
                {throw} | Should -not -Throw
            }
        }
    }
}

