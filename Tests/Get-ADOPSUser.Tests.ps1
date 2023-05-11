param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'Get-ADOPSUser' {
    BeforeAll {
        Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'DummyOrg' }
    }
    Context 'Parameters' {
        $TestCases = @(
            @{
                Name      = 'Organization'
                Mandatory = $false
                Type      = 'string'
            },
            @{
                Name      = 'Name'
                Mandatory = $true
                Type      = 'string'
            },
            @{
                Name      = 'Descriptor'
                Mandatory = $true
                Type      = 'string'
            },
            @{
                Name      = 'ContinuationToken'
                Mandatory = $false
                Type      = 'string'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases {
            Get-Command Get-ADOPSUser | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }

    Context 'Organization' {
        BeforeAll {
            Mock InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                [PSCustomObject]@{
                    Content    = @{
                        value = @(
                            @{
                                user = @{
                                    subjectKind    = 'user'
                                    metaType       = 'member'
                                    directoryAlias = 'john.doe'
                                    domain         = 'b3435cb9-0c61-4c5f-aa9d-eb022d95b57f'
                                    principalName  = 'john.doe@example.org'
                                    mailAddress    = 'john.doe@example.org'
                                    origin         = 'aad'
                                    originId       = 'ef317b7a-1db1-4e39-a87e-856a106b4a2f'
                                    displayName    = 'John Doe'
                                    url            = 'https://vssps.dev.azure.com/DummyOrg/_apis/Graph/Users/aad.am9obiBkb2Vqb2huIGRvZWpvaG4gZG9lam9obiBkb2U'
                                    descriptor     = 'aad.am9obiBkb2Vqb2huIGRvZWpvaG4gZG9lam9obiBkb2U'
                                }
                            }
                            @{
                                user = @{
                                    subjectKind    = 'user'
                                    metaType       = 'member'
                                    directoryAlias = 'john.doe2'
                                    domain         = '4fac19ba-89ff-4a26-9f00-ff0ea5df74e8'
                                    principalName  = 'john.doe2@example.org'
                                    mailAddress    = 'john.doe@example.org'
                                    origin         = 'aad'
                                    originId       = '47a0d6f2-dd29-4b7c-b28a-9088bbd76612'
                                    displayName    = 'John Doe2'
                                    url            = 'https://vssps.dev.azure.com/DummyOrg/_apis/Graph/Users/aad.am9obiBkb2Vqb2huIGRvZWpvaG4gZG9lam9obiBkb2U2'
                                    descriptor     = 'aad.am9obiBkb2Vqb2huIGRvZWpvaG4gZG9lam9obiBkb2U2'
                                }
                            }
                        )
                    }
                    StatusCode = 200
                    Headers    = @{
                    }
                }
            }
        }

        It 'Should not get organization from GetADOPSDefaultOrganization when organization parameter is used' {
            Get-ADOPSUser -Organization 'Organization'
            Should -Invoke GetADOPSDefaultOrganization -ModuleName ADOPS -Times 0 -Exactly
        }
        
        It 'Should get organization using GetADOPSDefaultOrganization when organization parameter is not used' {
            Get-ADOPSUser
            Should -Invoke GetADOPSDefaultOrganization -ModuleName ADOPS -Times 1 -Exactly
        }
    }

    Context 'Function returns all users' {
        BeforeAll {
            Mock InvokeADOPSRestMethod -ModuleName ADOPS -ParameterFilter {
                $Uri -notlike '*continuationToken*'
            } {
                [PSCustomObject]@{
                    Content    = @{
                        value = @(
                            @{
                                subjectKind    = 'user'
                                metaType       = 'member'
                                directoryAlias = 'john.doe'
                                domain         = 'b3435cb9-0c61-4c5f-aa9d-eb022d95b57f'
                                principalName  = 'john.doe@example.org'
                                mailAddress    = 'john.doe@example.org'
                                origin         = 'aad'
                                originId       = 'ef317b7a-1db1-4e39-a87e-856a106b4a2f'
                                displayName    = 'John Doe'
                                url            = 'https://vssps.dev.azure.com/DummyOrg/_apis/Graph/Users/aad.am9obiBkb2Vqb2huIGRvZWpvaG4gZG9lam9obiBkb2U'
                                descriptor     = 'aad.am9obiBkb2Vqb2huIGRvZWpvaG4gZG9lam9obiBkb2U'
                            
                            },
                            @{
                                subjectKind    = 'user'
                                metaType       = 'member'
                                directoryAlias = 'john.doe2'
                                domain         = '4fac19ba-89ff-4a26-9f00-ff0ea5df74e8'
                                principalName  = 'john.doe2@example.org'
                                mailAddress    = 'john.doe@example.org'
                                origin         = 'aad'
                                originId       = '47a0d6f2-dd29-4b7c-b28a-9088bbd76612'
                                displayName    = 'John Doe2'
                                url            = 'https://vssps.dev.azure.com/DummyOrg/_apis/Graph/Users/aad.am9obiBkb2Vqb2huIGRvZWpvaG4gZG9lam9obiBkb2U2'
                                descriptor     = 'aad.am9obiBkb2Vqb2huIGRvZWpvaG4gZG9lam9obiBkb2U2'
                            }
                        )
                    }
                    StatusCode = 200
                    Headers    = @{
                        'X-MS-ContinuationToken' = @('page2Token')
                    }
                }
            }
            Mock InvokeADOPSRestMethod -ModuleName ADOPS -ParameterFilter {
                $Uri -like '*continuationToken=page2Token*'
            } {
                [PSCustomObject]@{
                    Content    = @{
                        value = @(
                            @{
                                subjectKind    = 'user'
                                metaType       = 'member'
                                directoryAlias = 'john.doe3'
                                domain         = 'b3435cb9-0c61-4c5f-aa9d-eb022d95b57f'
                                principalName  = 'john.doe3@example.org'
                                mailAddress    = 'john.doe3@example.org'
                                origin         = 'aad'
                                originId       = '41cd5b95-508a-4d5b-b445-100d7a6890a6'
                                displayName    = 'John Doe3'
                                url            = 'https://vssps.dev.azure.com/DummyOrg/_apis/Graph/Users/aad.am9obiBkb2Vqb2huIGRvZWpvaG4gZG9lam9obiBkb2U3'
                                descriptor     = 'aad.am9obiBkb2Vqb2huIGRvZWpvaG4gZG9lam9obiBkb2U'
                            }
                        )
                    }
                    StatusCode = 200
                    Headers    = @{}
                }
            }
        }

        It 'Returns 3 users' {
            $result = Get-ADOPSUser -Organization 'DummyOrg'
            $result | Should -Not -BeNullOrEmpty
            $result | Should -HaveCount 3

        }

        It 'Calls InvokeADOPSRestMethod with the correct query params' {
            Get-ADOPSUser -Organization 'DummyOrg'
            Should -Invoke InvokeADOPSRestMethod -ModuleName ADOPS -Times 1 -Exactly -ParameterFilter { $Uri -eq 'https://vssps.dev.azure.com/DummyOrg/_apis/graph/users?api-version=6.0-preview.1' }
            Should -Invoke InvokeADOPSRestMethod -ModuleName ADOPS -Times 1 -Exactly -ParameterFilter { $Uri -eq 'https://vssps.dev.azure.com/DummyOrg/_apis/graph/users?api-version=6.0-preview.1&continuationToken=page2Token' }
        }
    }

    Context 'Function returns single user by descriptor' {
        BeforeAll {
            Mock InvokeADOPSRestMethod -ModuleName ADOPS {
                [PSCustomObject]@{
                    subjectKind    = 'user'
                    metaType       = 'member'
                    directoryAlias = 'john.doe'
                    domain         = 'b3435cb9-0c61-4c5f-aa9d-eb022d95b57f'
                    principalName  = 'john.doe@example.org'
                    mailAddress    = 'john.doe@example.org'
                    origin         = 'aad'
                    originId       = 'ef317b7a-1db1-4e39-a87e-856a106b4a2f'
                    displayName    = 'John Doe'
                    url            = 'https://vssps.dev.azure.com/DummyOrg/_apis/Graph/Users/aad.am9obiBkb2Vqb2huIGRvZWpvaG4gZG9lam9obiBkb2U'
                    descriptor     = 'aad.am9obiBkb2Vqb2huIGRvZWpvaG4gZG9lam9obiBkb2U'
                }
            }
        }

        It 'Returns user by descriptor' {
            Get-ADOPSUser -Descriptor 'aad.am9obiBkb2Vqb2huIGRvZWpvaG4gZG9lam9obiBkb2U' | Should -Not -BeNullOrEmpty
        }

        It 'Calls InvokeADOPSRestMethod with the correct query params' {
            Get-ADOPSUser -Descriptor 'aad.am9obiBkb2Vqb2huIGRvZWpvaG4gZG9lam9obiBkb2U'
            Should -Invoke InvokeADOPSRestMethod -ModuleName ADOPS -Times 1 -Exactly -ParameterFilter { $Uri -eq 'https://vssps.dev.azure.com/DummyOrg/_apis/graph/users/aad.am9obiBkb2Vqb2huIGRvZWpvaG4gZG9lam9obiBkb2U?api-version=6.0-preview.1' }
        }
    }

    Context 'Function returns users by query' {
        BeforeAll {
            Mock InvokeADOPSRestMethod -ModuleName ADOPS {
                @{
                    members           = @(
                        @{
                            user                = @{
                                subjectKind    = 'user'
                                metaType       = 'member'
                                directoryAlias = 'nomail@no'
                                domain         = '11111111-1111-1111-1111-111111111111'
                                principalName  = 'nomail@no'
                                mailAddress    = 'nomail@no'
                                origin         = 'aad'
                                originId       = '11111111-1111-1111-1111-111111111111'
                                displayName    = 'dummy.user'
                                _links         = @{
                                    self            = @{
                                        href = 'https://vssps.dev.azure.com/organization/_apis/Graph/Users/2U6MnTofiLmudoZye6zz2uwnyNaPJZf5nZQlqep9i38sjln2QjF2ODiZ25VxQR99bz3sSdQwGDRBoYwfl8Q35Ruz8UeT3auMwrk9VNvrbmnvAJXubyRAjmvN74iaCPFUsICFMVUHBYdg'
                                    }
                                    memberships     = @{
                                        href = 'https://vssps.dev.azure.com/organization/_apis/Graph/Memberships/2U6MnTofiLmudoZye6zz2uwnyNaPJZf5nZQlqep9i38sjln2QjF2ODiZ25VxQR99bz3sSdQwGDRBoYwfl8Q35Ruz8UeT3auMwrk9VNvrbmnvAJXubyRAjmvN74iaCPFUsICFMVUHBYdg'
                                    }
                                    membershipState = @{
                                        href = 'https://vssps.dev.azure.com/organization/_apis/Graph/MembershipStates/2U6MnTofiLmudoZye6zz2uwnyNaPJZf5nZQlqep9i38sjln2QjF2ODiZ25VxQR99bz3sSdQwGDRBoYwfl8Q35Ruz8UeT3auMwrk9VNvrbmnvAJXubyRAjmvN74iaCPFUsICFMVUHBYdg'
                                    }
                                    storageKey      = @{
                                        href = 'https://vssps.dev.azure.com/organization/_apis/Graph/StorageKeys/2U6MnTofiLmudoZye6zz2uwnyNaPJZf5nZQlqep9i38sjln2QjF2ODiZ25VxQR99bz3sSdQwGDRBoYwfl8Q35Ruz8UeT3auMwrk9VNvrbmnvAJXubyRAjmvN74iaCPFUsICFMVUHBYdg'
                                    }
                                    avatar          = @{
                                        href = 'https://dev.azure.com/organization/_apis/GraphProfile/MemberAvatars/2U6MnTofiLmudoZye6zz2uwnyNaPJZf5nZQlqep9i38sjln2QjF2ODiZ25VxQR99bz3sSdQwGDRBoYwfl8Q35Ruz8UeT3auMwrk9VNvrbmnvAJXubyRAjmvN74iaCPFUsICFMVUHBYdg'
                                    }
                                }
                                url            = 'https://vssps.dev.azure.com/organization/_apis/Graph/Users/2U6MnTofiLmudoZye6zz2uwnyNaPJZf5nZQlqep9i38sjln2QjF2ODiZ25VxQR99bz3sSdQwGDRBoYwfl8Q35Ruz8UeT3auMwrk9VNvrbmnvAJXubyRAjmvN74iaCPFUsICFMVUHBYdg'
                                descriptor     = '2U6MnTofiLmudoZye6zz2uwnyNaPJZf5nZQlqep9i38sjln2QjF2ODiZ25VxQR99bz3sSdQwGDRBoYwfl8Q35Ruz8UeT3auMwrk9VNvrbmnvAJXubyRAjmvN74iaCPFUsICFMVUHBYdg'
                            }
                            extensions          = @()
                            id                  = '11111111-1111-1111-1111-111111111111'
                            accessLevel         = @{
                                licensingSource    = 'account'
                                accountLicenseType = 'express'
                                msdnLicenseType    = 'none'
                                licenseDisplayName = 'Basic'
                                status             = 'active'
                                statusMessage      = ''
                                assignmentSource   = 'unknown'
                            }
                            lastAccessedDate    = '1901-01-01T00:00:00.0000000Z'
                            dateCreated         = '1901-01-01T00:00:00.0000000Z'
                            projectEntitlements = @()
                            groupAssignments    = @()
                        }
                    )
                    continuationToken = $null
                    totalCount        = 1
                    items             = @(
                        @{
                            user                = @{
                                subjectKind    = 'user'
                                metaType       = 'member'
                                directoryAlias = 'nomail@no'
                                domain         = '11111111-1111-1111-1111-111111111111'
                                principalName  = 'nomail@no'
                                mailAddress    = 'nomail@no'
                                origin         = 'aad'
                                originId       = '11111111-1111-1111-1111-111111111111'
                                displayName    = 'dummy.user'
                                _links         = @{
                                    self            = @{
                                        href = 'https://vssps.dev.azure.com/organization/_apis/Graph/Users/2U6MnTofiLmudoZye6zz2uwnyNaPJZf5nZQlqep9i38sjln2QjF2ODiZ25VxQR99bz3sSdQwGDRBoYwfl8Q35Ruz8UeT3auMwrk9VNvrbmnvAJXubyRAjmvN74iaCPFUsICFMVUHBYdg'
                                    }
                                    memberships     = @{
                                        href = 'https://vssps.dev.azure.com/organization/_apis/Graph/Memberships/2U6MnTofiLmudoZye6zz2uwnyNaPJZf5nZQlqep9i38sjln2QjF2ODiZ25VxQR99bz3sSdQwGDRBoYwfl8Q35Ruz8UeT3auMwrk9VNvrbmnvAJXubyRAjmvN74iaCPFUsICFMVUHBYdg'
                                    }
                                    membershipState = @{
                                        href = 'https://vssps.dev.azure.com/organization/_apis/Graph/MembershipStates/2U6MnTofiLmudoZye6zz2uwnyNaPJZf5nZQlqep9i38sjln2QjF2ODiZ25VxQR99bz3sSdQwGDRBoYwfl8Q35Ruz8UeT3auMwrk9VNvrbmnvAJXubyRAjmvN74iaCPFUsICFMVUHBYdg'
                                    }
                                    storageKey      = @{
                                        href = 'https://vssps.dev.azure.com/organization/_apis/Graph/StorageKeys/2U6MnTofiLmudoZye6zz2uwnyNaPJZf5nZQlqep9i38sjln2QjF2ODiZ25VxQR99bz3sSdQwGDRBoYwfl8Q35Ruz8UeT3auMwrk9VNvrbmnvAJXubyRAjmvN74iaCPFUsICFMVUHBYdg'
                                    }
                                    avatar          = @{
                                        href = 'https://dev.azure.com/organization/_apis/GraphProfile/MemberAvatars/2U6MnTofiLmudoZye6zz2uwnyNaPJZf5nZQlqep9i38sjln2QjF2ODiZ25VxQR99bz3sSdQwGDRBoYwfl8Q35Ruz8UeT3auMwrk9VNvrbmnvAJXubyRAjmvN74iaCPFUsICFMVUHBYdg'
                                    }
                                }
                                url            = 'https://vssps.dev.azure.com/organization/_apis/Graph/Users/2U6MnTofiLmudoZye6zz2uwnyNaPJZf5nZQlqep9i38sjln2QjF2ODiZ25VxQR99bz3sSdQwGDRBoYwfl8Q35Ruz8UeT3auMwrk9VNvrbmnvAJXubyRAjmvN74iaCPFUsICFMVUHBYdg'
                                descriptor     = '2U6MnTofiLmudoZye6zz2uwnyNaPJZf5nZQlqep9i38sjln2QjF2ODiZ25VxQR99bz3sSdQwGDRBoYwfl8Q35Ruz8UeT3auMwrk9VNvrbmnvAJXubyRAjmvN74iaCPFUsICFMVUHBYdg'
                            }
                            extensions          = @()
                            id                  = '11111111-1111-1111-1111-111111111111'
                            accessLevel         = @{
                                licensingSource    = 'account'
                                accountLicenseType = 'express'
                                msdnLicenseType    = 'none'
                                licenseDisplayName = 'Basic'
                                status             = 'active'
                                statusMessage      = ''
                                assignmentSource   = 'unknown'
                            }
                            lastAccessedDate    = '1901-01-01T00:00:00.0000000Z'
                            dateCreated         = '1901-01-01T00:00:00.0000000Z'
                            projectEntitlements = @()
                            groupAssignments    = @()
                        }
                    )
                }
            }
        }

        It 'Returns users by query string' {
            Get-ADOPSUser -Name 'something' | Should -Not -BeNullOrEmpty
        }

        It 'Calls InvokeADOPSRestMethod with the correct query pararms' {
            Get-ADOPSUser -Name 'john'
            Should -Invoke InvokeADOPSRestMethod -ModuleName ADOPS -Times 1 -Exactly -ParameterFilter { $Uri -eq "https://vsaex.dev.azure.com/DummyOrg/_apis/UserEntitlements?`$filter=name eq 'john'&`$orderBy=name Ascending&api-version=6.0-preview.3" }
        }
    }
}