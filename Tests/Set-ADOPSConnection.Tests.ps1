param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'Set-ADOPSConnection' {
    BeforeAll {
        InModuleScope -ModuleName ADOPS {
            Mock -CommandName NewAzToken -ModuleName ADOPS -MockWIth {
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

    Context 'Parameters' {
        $TestCases = @(
            @{
                Name = 'DefaultOrganization'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'ForceRefresh'
                Mandatory = $false
                Type = 'switch'
            }
        )

        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command Set-ADOPSConnection | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }

    Context 'DefaultOrganization - No previous connection made' {
        BeforeEach {
            InModuleScope -ModuleName ADOPS {
                Remove-Variable ADOPSCredentials -Scope Script -ErrorAction SilentlyContinue
            }
        }

        It 'Should call NewAzToken once to create connection' {
            $null = Set-ADOPSConnection -DefaultOrganization org1
            Should -Invoke -CommandName NewAzToken -ModuleName ADOPS -Times 1
        }

        It 'Should set defaultOrganization' {
            $null = Set-ADOPSConnection -DefaultOrganization org1
            InModuleScope -ModuleName ADOPS {
                $script:ADOPSCredentials.Default | Should -BeTrue
                $script:ADOPSCredentials.Organization | Should -Be 'org1'
            }
        }

        It 'Should throw if NewAzToken fails' {
            InModuleScope -ModuleName ADOPS {
                Mock -CommandName NewAzToken -MockWith { Throw }
            }
            {Set-ADOPSConnection -DefaultOrganization org1} | Should -Throw -ExpectedMessage 'No usable ADOPS credentials found. Use Connect-AzAccount or az login to connect.'   
        }
    }

    Context 'DefaultOrganization - Previous connection made, no default set, one org.' {
        BeforeEach {
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
                        Default = $false
                    }
                )
            }
        }

        It 'Should set defaultOrganization' {
            $null = Set-ADOPSConnection -DefaultOrganization org1
            InModuleScope -ModuleName ADOPS {
                $NewDefault = $script:ADOPSCredentials.Where({$_.Default})
                $NewDefault.Default | Should -BeTrue
                $NewDefault.Organization | Should -Be 'org1'
            }
        }
    }

    Context 'DefaultOrganization - Previous connection made, default set, one org.' {
        BeforeEach {
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
        }

        It 'Should set defaultOrganization' {
            $null = Set-ADOPSConnection -DefaultOrganization org1
            InModuleScope -ModuleName ADOPS {
                $NewDefault = $script:ADOPSCredentials.Where({$_.Default})
                $NewDefault.Default | Should -BeTrue
                $NewDefault.Organization | Should -Be 'org1'
            }
        }
    }

    Context 'DefaultOrganization - Previous connection made, no default set, two org.' {
        BeforeEach {
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
                )
            }
        }

        It 'Should set defaultOrganization' {
            $null = Set-ADOPSConnection -DefaultOrganization org2
            InModuleScope -ModuleName ADOPS {
                $NewDefault = $script:ADOPSCredentials.Where({$_.Default})
                $NewDefault.Default | Should -BeTrue
                $NewDefault.Organization | Should -Be 'org2'
            }
        }

        It 'No other connections should be set as default' {
            $null = Set-ADOPSConnection -DefaultOrganization org2
            InModuleScope -ModuleName ADOPS {
                $NewDefault = $script:ADOPSCredentials.Where({$_.Default})
                $NewDefault.Count | Should -Be 1
            }
        }
    }

    Context 'DefaultOrganization - Previous connection made, default set, two org.' {
        BeforeEach {
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

        It 'Should set defaultOrganization' {
            $null = Set-ADOPSConnection -DefaultOrganization org1
            InModuleScope -ModuleName ADOPS {
                $NewDefault = $script:ADOPSCredentials.Where({$_.Default})
                $NewDefault.Default | Should -BeTrue
                $NewDefault.Organization | Should -Be 'org1'
            }
        }

        It 'No other connections should be set as default' {
            $null = Set-ADOPSConnection -DefaultOrganization org1
            InModuleScope -ModuleName ADOPS {
                $NewDefault = $script:ADOPSCredentials.Where({$_.Default})
                $NewDefault.Count | Should -Be 1
            }
        }
        It 'Should throw if given a bad organization.' {
            {Set-ADOPSConnection -DefaultOrganization org3} | Should -Throw -ExpectedMessage 'No organization with name org3 found.'
        }
    }

    Context 'ForceRefresh' {
        BeforeEach {
            InModuleScope -ModuleName ADOPS {
                $script:ADOPSCredentials = @(
                    @{
                        Organization = "oldOrg"
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
                        Organization = "oldOrg2"
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
                )
            }
        }

        It 'Should remove and reset all existing connections' {
            $null = Set-ADOPSConnection -ForceRefresh
            InModuleScope -ModuleName ADOPS {
                $NewDefault = $script:ADOPSCredentials.Where({$_.Default})
                $NewDefault.Organization | Should -Be 'org1'
            }
        }

        It 'Should remove and reset all existing connections, verify count' {
            $null = Set-ADOPSConnection -ForceRefresh
            InModuleScope -ModuleName ADOPS {
                $NewDefault = $script:ADOPSCredentials.Where({$_.Default})
                $NewDefault.count | Should -Be 1
            }
        }
    }
}

