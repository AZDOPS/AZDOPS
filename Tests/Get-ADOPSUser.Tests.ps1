Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot\..\Source\ADOPS -Force

Describe "Get-ADOPSUser" {
    Context "Parameters" {
        $TestCases = @(
            @{
                Name = 'Organization'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'Name'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'Descriptor'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'ContinuationToken'
                Mandatory = $false
                Type = 'string'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command Get-ADOPSUser | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }

    Context "Function returns all users" {
        BeforeAll {
            Mock InvokeADOPSRestMethod -ModuleName ADOPS -ParameterFilter {
                $Uri -notlike '*continuationToken*'
            } {
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
                                user = @{
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
                            }
                        )
                    }
                    StatusCode = 200
                    Headers    = @{}
                }
            }
            Mock -CommandName GetADOPSHeader -ModuleName ADOPS -MockWith {
                @{
                    Header       = @{
                        'Authorization' = 'Basic Base64=='
                    }
                    Organization = 'DummyOrg'
                }
            }
        }

        It "Returns 3 users" {
            $result = Get-ADOPSUser -Organization 'DummyOrg'
            $result | Should -Not -BeNullOrEmpty
            $result | Should -HaveCount 3

        }

        It 'Calls InvokeADOPSRestMethod with the correct query params' {
            Get-ADOPSUser -Organization 'DummyOrg'
            Should -Invoke InvokeADOPSRestMethod -ModuleName ADOPS -Times 1 -Exactly -ParameterFilter { $Uri -eq "https://vssps.dev.azure.com/DummyOrg/_apis/graph/users?api-version=6.0-preview.1" }
            Should -Invoke InvokeADOPSRestMethod -ModuleName ADOPS -Times 1 -Exactly -ParameterFilter { $Uri -eq "https://vssps.dev.azure.com/DummyOrg/_apis/graph/users?api-version=6.0-preview.1&continuationToken=page2Token" }
        }
    }

    Context "Function returns single user by descriptor" {
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
            Mock -CommandName GetADOPSHeader -ModuleName ADOPS -MockWith {
                @{
                    Header       = @{
                        'Authorization' = 'Basic Base64=='
                    }
                    Organization = 'DummyOrg'
                }
            }
        }

        It "Returns user by descriptor" {
            Get-ADOPSUser -Organization 'DummyOrg' -Descriptor 'aad.am9obiBkb2Vqb2huIGRvZWpvaG4gZG9lam9obiBkb2U' | Should -Not -BeNullOrEmpty
        }

        It 'Calls InvokeADOPSRestMethod with the correct query params' {
            Get-ADOPSUser -Organization 'DummyOrg' -Descriptor 'aad.am9obiBkb2Vqb2huIGRvZWpvaG4gZG9lam9obiBkb2U'
            Should -Invoke InvokeADOPSRestMethod -ModuleName ADOPS -Times 1 -Exactly -ParameterFilter { $Uri -eq "https://vssps.dev.azure.com/DummyOrg/_apis/graph/users/aad.am9obiBkb2Vqb2huIGRvZWpvaG4gZG9lam9obiBkb2U?api-version=6.0-preview.1" }
        }
    }

    Context "Function returns users by query" {
        BeforeAll {
            Mock InvokeADOPSRestMethod -ModuleName ADOPS {
                [PSCustomObject]@{
                    members = @(
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
            }
            Mock -CommandName GetADOPSHeader -ModuleName ADOPS -MockWith {
                @{
                    Header       = @{
                        'Authorization' = 'Basic Base64=='
                    }
                    Organization = 'DummyOrg'
                }
            }
        }

        It "Returns users by query string" {
            Get-ADOPSUser -Organization 'DummyOrg' -Name 'something' | Should -Not -BeNullOrEmpty
        }

        It 'Calls InvokeADOPSRestMethod with the correct query pararms' {
            Get-ADOPSUser -Organization 'DummyOrg' -Name 'john'
            Should -Invoke InvokeADOPSRestMethod -ModuleName ADOPS -Times 1 -Exactly -ParameterFilter { $Uri -eq "https://vsaex.dev.azure.com/DummyOrg/_apis/UserEntitlements?`$filter=name eq 'john'&`$orderBy=name Ascending&api-version=6.0-preview.3" }
        }
    }
}