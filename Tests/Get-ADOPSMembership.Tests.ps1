param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe "Get-ADOPSMembership" {
    BeforeAll {
        Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'DummyOrg' }
    }

    Context "Parameters" {
        $TestCases = @(
            @{
                Name      = 'Organization'
                Mandatory = $false
                Type      = 'string'
            },
            @{
                Name      = 'Descriptor'
                Mandatory = $true
                Type      = 'string'
            },
            @{
                Name      = 'Direction'
                Mandatory = $false
                Type      = 'string'
            }
        )

        It 'Should have parameter <_.Name>' -TestCases $TestCases {
            Get-Command Get-ADOPSMembership | Should-HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }

        It 'Should throw if Direction is not up or down' {
            { Get-ADOPSMembership -Descriptor 'vssgp.abc' -Direction 'invalid' } | Should-Throw
        }
    }

    Context 'URI' {
        BeforeAll {
            Mock InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                @{ value = @() }
            }
        }

        It 'Calls InvokeADOPSRestMethod with the correct URI when direction is up' {
            Get-ADOPSMembership -Organization 'DummyOrg' -Descriptor 'vssgp.abc123'
            Should-Invoke InvokeADOPSRestMethod -ModuleName ADOPS -Times 1 -Exactly -ParameterFilter {
                $Uri -eq 'https://vssps.dev.azure.com/DummyOrg/_apis/graph/Memberships/vssgp.abc123?direction=up&depth=1&api-version=7.2-preview.1'
            }
        }

        It 'Calls InvokeADOPSRestMethod with the correct URI when direction is down' {
            Get-ADOPSMembership -Organization 'DummyOrg' -Descriptor 'vssgp.abc123' -Direction 'down'
            Should-Invoke InvokeADOPSRestMethod -ModuleName ADOPS -Times 1 -Exactly -ParameterFilter {
                $Uri -eq 'https://vssps.dev.azure.com/DummyOrg/_apis/graph/Memberships/vssgp.abc123?direction=down&depth=1&api-version=7.2-preview.1'
            }
        }
    }

    Context 'Organization' {
        BeforeAll {
            Mock InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                @{ value = @() }
            }
        }

        It 'Should not call GetADOPSDefaultOrganization when Organization parameter is provided' {
            Get-ADOPSMembership -Organization 'DummyOrg' -Descriptor 'vssgp.abc123'
            Should-Invoke GetADOPSDefaultOrganization -ModuleName ADOPS -Times 0 -Exactly
        }

        It 'Should call GetADOPSDefaultOrganization when Organization parameter is not provided' {
            Get-ADOPSMembership -Descriptor 'vssgp.abc123'
            Should-Invoke GetADOPSDefaultOrganization -ModuleName ADOPS -Times 1 -Exactly
        }
    }

    Context 'Direction up - vssgp container descriptor' {
        BeforeAll {
            # API response format per MS Learn: https://learn.microsoft.com/en-us/rest/api/azure/devops/graph/memberships/list?view=azure-devops-rest-7.2
            Mock InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                @{
                    value = @(
                        @{
                            containerDescriptor = 'vssgp.KZxAEOS5OBwwvtcidMzAKgkPrhLSpJ1SvwQj1CGj72xMmaz6tnXironO0TxMcas9TWir5sbN91JYp90YgbiBcSMcF94FaNmYl1dQSIOMUKPjwFQloaEG4l8rdlvTiSJTEjFxw5QgWrP1'
                            memberDescriptor    = 'aad.am9obiBkb2Vqb2huIGRvZWpvaG4gZG9lam9obiBkb2U'
                        }
                    )
                }
            }
            Mock Get-ADOPSGroup -ModuleName ADOPS -MockWith {
                [PSCustomObject]@{
                    subjectKind   = 'group'
                    displayName   = 'Readers'
                    descriptor    = 'vssgp.KZxAEOS5OBwwvtcidMzAKgkPrhLSpJ1SvwQj1CGj72xMmaz6tnXironO0TxMcas9TWir5sbN91JYp90YgbiBcSMcF94FaNmYl1dQSIOMUKPjwFQloaEG4l8rdlvTiSJTEjFxw5QgWrP1'
                    principalName = '[DummyOrg]\\Readers'
                    origin        = 'vsts'
                    originId      = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'
                    url           = 'https://vssps.dev.azure.com/DummyOrg/_apis/Graph/Groups/vssgp.KZxAEOS5OBwwvtcidMzAKgkPrhLSpJ1SvwQj1CGj72xMmaz6tnXironO0TxMcas9TWir5sbN91JYp90YgbiBcSMcF94FaNmYl1dQSIOMUKPjwFQloaEG4l8rdlvTiSJTEjFxw5QgWrP1'
                }
            }
        }

        It 'Returns a result' {
            $result = Get-ADOPSMembership -Organization 'DummyOrg' -Descriptor 'aad.am9obiBkb2Vqb2huIGRvZWpvaG4gZG9lam9obiBkb2U'
            $result | Should-NotBeNull
        }

        It 'Calls Get-ADOPSGroup with the vssgp containerDescriptor' {
            Get-ADOPSMembership -Organization 'DummyOrg' -Descriptor 'aad.am9obiBkb2Vqb2huIGRvZWpvaG4gZG9lam9obiBkb2U'
            Should-Invoke Get-ADOPSGroup -ModuleName ADOPS -Times 1 -Exactly -ParameterFilter {
                $Descriptor -eq 'vssgp.KZxAEOS5OBwwvtcidMzAKgkPrhLSpJ1SvwQj1CGj72xMmaz6tnXironO0TxMcas9TWir5sbN91JYp90YgbiBcSMcF94FaNmYl1dQSIOMUKPjwFQloaEG4l8rdlvTiSJTEjFxw5QgWrP1'
            }
        }
    }

    Context 'Direction up - aadgp container descriptor' {
        BeforeAll {
            Mock InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                @{
                    value = @(
                        @{
                            containerDescriptor = 'aadgp.YTBiMWMyZDMtZTRmNS1nNmg3LWk4ajktazFsMm0zbjRvNXA2'
                            memberDescriptor    = 'aad.am9obiBkb2Vqb2huIGRvZWpvaG4gZG9lam9obiBkb2U'
                        }
                    )
                }
            }
            Mock Get-ADOPSGroup -ModuleName ADOPS -MockWith {
                [PSCustomObject]@{
                    subjectKind   = 'group'
                    displayName   = 'AAD Group'
                    descriptor    = 'aadgp.YTBiMWMyZDMtZTRmNS1nNmg3LWk4ajktazFsMm0zbjRvNXA2'
                    principalName = '[DummyOrg]\\AAD Group'
                    origin        = 'aad'
                    originId      = 'a0b1c2d3-e4f5-a6b7-c8d9-e0f1a2b3c4d5'
                    url           = 'https://vssps.dev.azure.com/DummyOrg/_apis/Graph/Groups/aadgp.YTBiMWMyZDMtZTRmNS1nNmg3LWk4ajktazFsMm0zbjRvNXA2'
                }
            }
        }

        It 'Returns a result' {
            $result = Get-ADOPSMembership -Organization 'DummyOrg' -Descriptor 'aad.am9obiBkb2Vqb2huIGRvZWpvaG4gZG9lam9obiBkb2U'
            $result | Should-NotBeNull
        }

        It 'Calls Get-ADOPSGroup with the aadgp containerDescriptor' {
            Get-ADOPSMembership -Organization 'DummyOrg' -Descriptor 'aad.am9obiBkb2Vqb2huIGRvZWpvaG4gZG9lam9obiBkb2U'
            Should-Invoke Get-ADOPSGroup -ModuleName ADOPS -Times 1 -Exactly -ParameterFilter {
                $Descriptor -eq 'aadgp.YTBiMWMyZDMtZTRmNS1nNmg3LWk4ajktazFsMm0zbjRvNXA2'
            }
        }
    }

    Context 'Direction up - aad container descriptor' {
        BeforeAll {
            Mock InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                @{
                    value = @(
                        @{
                            containerDescriptor = 'aad.am9obiBkb2Vqb2huIGRvZWpvaG4gZG9lam9obiBkb2U'
                            memberDescriptor    = 'vssgp.KZxAEOS5OBwwvtcidMzAKgkPrhLSpJ1SvwQj1CGj72xMmaz6tnXironO0TxMcas9TWir5sbN91JYp90YgbiBcSMcF94FaNmYl1dQSIOMUKPjwFQloaEG4l8rdlvTiSJTEjFxw5QgWrP1'
                        }
                    )
                }
            }
            Mock Get-ADOPSUser -ModuleName ADOPS -MockWith {
                [PSCustomObject]@{
                    subjectKind   = 'user'
                    displayName   = 'John Doe'
                    descriptor    = 'aad.am9obiBkb2Vqb2huIGRvZWpvaG4gZG9lam9obiBkb2U'
                    principalName = 'john.doe@example.org'
                    mailAddress   = 'john.doe@example.org'
                    origin        = 'aad'
                    originId      = 'ef317b7a-1db1-4e39-a87e-856a106b4a2f'
                    url           = 'https://vssps.dev.azure.com/DummyOrg/_apis/Graph/Users/aad.am9obiBkb2Vqb2huIGRvZWpvaG4gZG9lam9obiBkb2U'
                }
            }
        }

        It 'Returns a result' {
            $result = Get-ADOPSMembership -Organization 'DummyOrg' -Descriptor 'vssgp.KZxAEOS5OBwwvtcidMzAKgkPrhLSpJ1SvwQj1CGj72xMmaz6tnXironO0TxMcas9TWir5sbN91JYp90YgbiBcSMcF94FaNmYl1dQSIOMUKPjwFQloaEG4l8rdlvTiSJTEjFxw5QgWrP1'
            $result | Should-NotBeNull
        }

        It 'Calls Get-ADOPSUser with the aad containerDescriptor' {
            Get-ADOPSMembership -Organization 'DummyOrg' -Descriptor 'vssgp.KZxAEOS5OBwwvtcidMzAKgkPrhLSpJ1SvwQj1CGj72xMmaz6tnXironO0TxMcas9TWir5sbN91JYp90YgbiBcSMcF94FaNmYl1dQSIOMUKPjwFQloaEG4l8rdlvTiSJTEjFxw5QgWrP1'
            Should-Invoke Get-ADOPSUser -ModuleName ADOPS -Times 1 -Exactly -ParameterFilter {
                $Descriptor -eq 'aad.am9obiBkb2Vqb2huIGRvZWpvaG4gZG9lam9obiBkb2U'
            }
        }
    }

    Context 'Direction down - vssgp member descriptor' {
        BeforeAll {
            Mock InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                @{
                    value = @(
                        @{
                            containerDescriptor = 'vssgp.KZxAEOS5OBwwvtcidMzAKgkPrhLSpJ1SvwQj1CGj72xMmaz6tnXironO0TxMcas9TWir5sbN91JYp90YgbiBcSMcF94FaNmYl1dQSIOMUKPjwFQloaEG4l8rdlvTiSJTEjFxw5QgWrP1'
                            memberDescriptor    = 'vssgp.60AL7JP86iP6lpQs2ejp9v8vgpaxLWiiD1GK1zSEDMoHaQnSBunvfc3VixVcMoXlh8omp0yP1lVNAFoLw07MLHhF9aNM8EjsniV0Ok9sniqZj3MoiHWR3vEc4xuYK1T1HnhgxlZVmk0G'
                        }
                    )
                }
            }
            Mock Get-ADOPSGroup -ModuleName ADOPS -MockWith {
                [PSCustomObject]@{
                    subjectKind   = 'group'
                    displayName   = 'Contributors'
                    descriptor    = 'vssgp.60AL7JP86iP6lpQs2ejp9v8vgpaxLWiiD1GK1zSEDMoHaQnSBunvfc3VixVcMoXlh8omp0yP1lVNAFoLw07MLHhF9aNM8EjsniV0Ok9sniqZj3MoiHWR3vEc4xuYK1T1HnhgxlZVmk0G'
                    principalName = '[DummyOrg]\\Contributors'
                    origin        = 'vsts'
                    originId      = 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb'
                    url           = 'https://vssps.dev.azure.com/DummyOrg/_apis/Graph/Groups/vssgp.60AL7JP86iP6lpQs2ejp9v8vgpaxLWiiD1GK1zSEDMoHaQnSBunvfc3VixVcMoXlh8omp0yP1lVNAFoLw07MLHhF9aNM8EjsniV0Ok9sniqZj3MoiHWR3vEc4xuYK1T1HnhgxlZVmk0G'
                }
            }
        }

        It 'Returns a result' {
            $result = Get-ADOPSMembership -Organization 'DummyOrg' -Descriptor 'vssgp.KZxAEOS5OBwwvtcidMzAKgkPrhLSpJ1SvwQj1CGj72xMmaz6tnXironO0TxMcas9TWir5sbN91JYp90YgbiBcSMcF94FaNmYl1dQSIOMUKPjwFQloaEG4l8rdlvTiSJTEjFxw5QgWrP1' -Direction 'down'
            $result | Should-NotBeNull
        }

        It 'Calls Get-ADOPSGroup with the vssgp memberDescriptor' {
            Get-ADOPSMembership -Organization 'DummyOrg' -Descriptor 'vssgp.KZxAEOS5OBwwvtcidMzAKgkPrhLSpJ1SvwQj1CGj72xMmaz6tnXironO0TxMcas9TWir5sbN91JYp90YgbiBcSMcF94FaNmYl1dQSIOMUKPjwFQloaEG4l8rdlvTiSJTEjFxw5QgWrP1' -Direction 'down'
            Should-Invoke Get-ADOPSGroup -ModuleName ADOPS -Times 1 -Exactly -ParameterFilter {
                $Descriptor -eq 'vssgp.60AL7JP86iP6lpQs2ejp9v8vgpaxLWiiD1GK1zSEDMoHaQnSBunvfc3VixVcMoXlh8omp0yP1lVNAFoLw07MLHhF9aNM8EjsniV0Ok9sniqZj3MoiHWR3vEc4xuYK1T1HnhgxlZVmk0G'
            }
        }
    }

    Context 'Direction down - aad member descriptor' {
        BeforeAll {
            Mock InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                @{
                    value = @(
                        @{
                            containerDescriptor = 'vssgp.KZxAEOS5OBwwvtcidMzAKgkPrhLSpJ1SvwQj1CGj72xMmaz6tnXironO0TxMcas9TWir5sbN91JYp90YgbiBcSMcF94FaNmYl1dQSIOMUKPjwFQloaEG4l8rdlvTiSJTEjFxw5QgWrP1'
                            memberDescriptor    = 'aad.am9obiBkb2Vqb2huIGRvZWpvaG4gZG9lam9obiBkb2U'
                        }
                    )
                }
            }
            Mock Get-ADOPSUser -ModuleName ADOPS -MockWith {
                [PSCustomObject]@{
                    subjectKind   = 'user'
                    displayName   = 'John Doe'
                    descriptor    = 'aad.am9obiBkb2Vqb2huIGRvZWpvaG4gZG9lam9obiBkb2U'
                    principalName = 'john.doe@example.org'
                    mailAddress   = 'john.doe@example.org'
                    origin        = 'aad'
                    originId      = 'ef317b7a-1db1-4e39-a87e-856a106b4a2f'
                    url           = 'https://vssps.dev.azure.com/DummyOrg/_apis/Graph/Users/aad.am9obiBkb2Vqb2huIGRvZWpvaG4gZG9lam9obiBkb2U'
                }
            }
        }

        It 'Returns a result' {
            $result = Get-ADOPSMembership -Organization 'DummyOrg' -Descriptor 'vssgp.KZxAEOS5OBwwvtcidMzAKgkPrhLSpJ1SvwQj1CGj72xMmaz6tnXironO0TxMcas9TWir5sbN91JYp90YgbiBcSMcF94FaNmYl1dQSIOMUKPjwFQloaEG4l8rdlvTiSJTEjFxw5QgWrP1' -Direction 'down'
            $result | Should-NotBeNull
        }

        It 'Calls Get-ADOPSUser with the aad memberDescriptor' {
            Get-ADOPSMembership -Organization 'DummyOrg' -Descriptor 'vssgp.KZxAEOS5OBwwvtcidMzAKgkPrhLSpJ1SvwQj1CGj72xMmaz6tnXironO0TxMcas9TWir5sbN91JYp90YgbiBcSMcF94FaNmYl1dQSIOMUKPjwFQloaEG4l8rdlvTiSJTEjFxw5QgWrP1' -Direction 'down'
            Should-Invoke Get-ADOPSUser -ModuleName ADOPS -Times 1 -Exactly -ParameterFilter {
                $Descriptor -eq 'aad.am9obiBkb2Vqb2huIGRvZWpvaG4gZG9lam9obiBkb2U'
            }
        }
    }

    Context 'Empty membership response' {
        BeforeAll {
            Mock InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                @{ value = @() }
            }
        }

        It 'Returns empty result when no memberships found with direction up' {
            $result = Get-ADOPSMembership -Organization 'DummyOrg' -Descriptor 'vssgp.abc123'
            $result | Should-BeNull
        }

        It 'Returns empty result when no memberships found with direction down' {
            $result = Get-ADOPSMembership -Organization 'DummyOrg' -Descriptor 'vssgp.abc123' -Direction 'down'
            $result | Should-BeNull
        }
    }
}