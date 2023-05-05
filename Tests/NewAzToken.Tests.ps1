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

}