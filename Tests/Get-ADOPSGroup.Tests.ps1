param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe "Get-ADOPSGroup" {
    BeforeAll {
        Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'DummyOrg' }
    }
    
    Context "Parameters" {
        $TestCases = @(
            @{
                Name = 'Organization'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'ContinuationToken'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'Descriptor'
                Mandatory = $false
                Type = 'string'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command Get-ADOPSGroup | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }

    Context 'Uri' {
        BeforeAll {
            Mock InvokeADOPSRestMethod -ModuleName ADOPS -MockWith { 
                @{
                    Content =  @{
                        value = $URI
                    }
                    Headers = @{}
                }
                
            }
        }

        It 'Verifying URI, no continuationtoken' {
            $Required = 'https://vssps.dev.azure.com/Organization/_apis/graph/groups?api-version=7.1-preview.1'
            $Actual = Get-ADOPSGroup -Organization 'Organization'
            $Actual.OriginalString | Should -Be $Required
        }

        It 'Verifying URI, with continuationtoken' {
            $Required = 'https://vssps.dev.azure.com/Organization/_apis/graph/groups?continuationToken=page2token&api-version=7.1-preview.1'
            $Actual = Get-ADOPSGroup -Organization 'Organization' -ContinuationToken 'page2token'
            $Actual.OriginalString | Should -Be $Required
        }
    }


    Context 'Organization' {
        BeforeAll {
            Mock InvokeADOPSRestMethod -ModuleName ADOPS -MockWith { 
                @{
                    Content    = @{
                        value = @(
                            @{
                                subjectKind = 'group'
                                description = 'group1'
                                domain = 'vstfs:///Classification/TeamProject/aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'
                                principalName = '[team]\\Readers'
                                mailAddress = $null
                                origin = 'vsts'
                                originId = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'
                                displayName = 'Readers'
                                _links = @{
                                    self = @{
                                    href = 'https://vssps.dev.azure.com/organization/_apis/Graph/Groups/vssgp.KZxAEOS5OBwwvtcidMzAKgkPrhLSpJ1SvwQj1CGj72xMmaz6tnXironO0TxMcas9TWir5sbN91JYp90YgbiBcSMcF94FaNmYl1dQSIOMUKPjwFQloaEG4l8rdlvTiSJTEjFxw5QgWrP1'
                                    }
                                    memberships = @{
                                    href = 'https://vssps.dev.azure.com/organization/_apis/Graph/Memberships/vssgp.KZxAEOS5OBwwvtcidMzAKgkPrhLSpJ1SvwQj1CGj72xMmaz6tnXironO0TxMcas9TWir5sbN91JYp90YgbiBcSMcF94FaNmYl1dQSIOMUKPjwFQloaEG4l8rdlvTiSJTEjFxw5QgWrP1'
                                    }
                                    membershipState = @{
                                    href = 'https://vssps.dev.azure.com/organization/_apis/Graph/MembershipStates/vssgp.KZxAEOS5OBwwvtcidMzAKgkPrhLSpJ1SvwQj1CGj72xMmaz6tnXironO0TxMcas9TWir5sbN91JYp90YgbiBcSMcF94FaNmYl1dQSIOMUKPjwFQloaEG4l8rdlvTiSJTEjFxw5QgWrP1'
                                    }
                                    storageKey = @{
                                    href = 'https://vssps.dev.azure.com/organization/_apis/Graph/StorageKeys/vssgp.KZxAEOS5OBwwvtcidMzAKgkPrhLSpJ1SvwQj1CGj72xMmaz6tnXironO0TxMcas9TWir5sbN91JYp90YgbiBcSMcF94FaNmYl1dQSIOMUKPjwFQloaEG4l8rdlvTiSJTEjFxw5QgWrP1'
                                    }
                                }
                                url = 'https://vssps.dev.azure.com/organization/_apis/Graph/Groups/vssgp.KZxAEOS5OBwwvtcidMzAKgkPrhLSpJ1SvwQj1CGj72xMmaz6tnXironO0TxMcas9TWir5sbN91JYp90YgbiBcSMcF94FaNmYl1dQSIOMUKPjwFQloaEG4l8rdlvTiSJTEjFxw5QgWrP1'
                                descriptor = 'vssgp.KZxAEOS5OBwwvtcidMzAKgkPrhLSpJ1SvwQj1CGj72xMmaz6tnXironO0TxMcas9TWir5sbN91JYp90YgbiBcSMcF94FaNmYl1dQSIOMUKPjwFQloaEG4l8rdlvTiSJTEjFxw5QgWrP1'
                            }
                        )
                    }
                    StatusCode = 200
                    Headers    = @{}
                }
            }
        }

        It 'Should get not organization from GetADOPSDefaultOrganization when organization parameter is used' {
            Get-ADOPSGroup -Organization 'Organization'
            Should -Invoke GetADOPSDefaultOrganization -ModuleName ADOPS -Times 0 -Exactly
        }
        
        It 'Should get organization using GetADOPSDefaultOrganization when organization parameter is not used' {
            Get-ADOPSGroup
            Should -Invoke GetADOPSDefaultOrganization -ModuleName ADOPS -Times 1 -Exactly
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
                                subjectKind = 'group'
                                description = 'group1'
                                domain = 'vstfs:///Classification/TeamProject/aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'
                                principalName = '[team]\\Readers'
                                mailAddress = $null
                                origin = 'vsts'
                                originId = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'
                                displayName = 'Readers'
                                _links = @{
                                    self = @{
                                    href = 'https://vssps.dev.azure.com/organization/_apis/Graph/Groups/vssgp.KZxAEOS5OBwwvtcidMzAKgkPrhLSpJ1SvwQj1CGj72xMmaz6tnXironO0TxMcas9TWir5sbN91JYp90YgbiBcSMcF94FaNmYl1dQSIOMUKPjwFQloaEG4l8rdlvTiSJTEjFxw5QgWrP1'
                                    }
                                    memberships = @{
                                    href = 'https://vssps.dev.azure.com/organization/_apis/Graph/Memberships/vssgp.KZxAEOS5OBwwvtcidMzAKgkPrhLSpJ1SvwQj1CGj72xMmaz6tnXironO0TxMcas9TWir5sbN91JYp90YgbiBcSMcF94FaNmYl1dQSIOMUKPjwFQloaEG4l8rdlvTiSJTEjFxw5QgWrP1'
                                    }
                                    membershipState = @{
                                    href = 'https://vssps.dev.azure.com/organization/_apis/Graph/MembershipStates/vssgp.KZxAEOS5OBwwvtcidMzAKgkPrhLSpJ1SvwQj1CGj72xMmaz6tnXironO0TxMcas9TWir5sbN91JYp90YgbiBcSMcF94FaNmYl1dQSIOMUKPjwFQloaEG4l8rdlvTiSJTEjFxw5QgWrP1'
                                    }
                                    storageKey = @{
                                    href = 'https://vssps.dev.azure.com/organization/_apis/Graph/StorageKeys/vssgp.KZxAEOS5OBwwvtcidMzAKgkPrhLSpJ1SvwQj1CGj72xMmaz6tnXironO0TxMcas9TWir5sbN91JYp90YgbiBcSMcF94FaNmYl1dQSIOMUKPjwFQloaEG4l8rdlvTiSJTEjFxw5QgWrP1'
                                    }
                                }
                                url = 'https://vssps.dev.azure.com/organization/_apis/Graph/Groups/vssgp.KZxAEOS5OBwwvtcidMzAKgkPrhLSpJ1SvwQj1CGj72xMmaz6tnXironO0TxMcas9TWir5sbN91JYp90YgbiBcSMcF94FaNmYl1dQSIOMUKPjwFQloaEG4l8rdlvTiSJTEjFxw5QgWrP1'
                                descriptor = 'vssgp.KZxAEOS5OBwwvtcidMzAKgkPrhLSpJ1SvwQj1CGj72xMmaz6tnXironO0TxMcas9TWir5sbN91JYp90YgbiBcSMcF94FaNmYl1dQSIOMUKPjwFQloaEG4l8rdlvTiSJTEjFxw5QgWrP1'
                            },
                            @{
                                subjectKind = 'group'
                                description = 'group2'
                                domain = 'vstfs:///Classification/TeamProject/aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'
                                principalName = '[team]\\Readers'
                                mailAddress = $null
                                origin = 'vsts'
                                originId = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'
                                displayName = 'Readers'
                                _links = @{
                                    self = @{
                                    href = 'https://vssps.dev.azure.com/organization/_apis/Graph/Groups/vssgp.KZxAEOS5OBwwvtcidMzAKgkPrhLSpJ1SvwQj1CGj72xMmaz6tnXironO0TxMcas9TWir5sbN91JYp90YgbiBcSMcF94FaNmYl1dQSIOMUKPjwFQloaEG4l8rdlvTiSJTEjFxw5QgWrP1'
                                    }
                                    memberships = @{
                                    href = 'https://vssps.dev.azure.com/organization/_apis/Graph/Memberships/vssgp.KZxAEOS5OBwwvtcidMzAKgkPrhLSpJ1SvwQj1CGj72xMmaz6tnXironO0TxMcas9TWir5sbN91JYp90YgbiBcSMcF94FaNmYl1dQSIOMUKPjwFQloaEG4l8rdlvTiSJTEjFxw5QgWrP1'
                                    }
                                    membershipState = @{
                                    href = 'https://vssps.dev.azure.com/organization/_apis/Graph/MembershipStates/vssgp.KZxAEOS5OBwwvtcidMzAKgkPrhLSpJ1SvwQj1CGj72xMmaz6tnXironO0TxMcas9TWir5sbN91JYp90YgbiBcSMcF94FaNmYl1dQSIOMUKPjwFQloaEG4l8rdlvTiSJTEjFxw5QgWrP1'
                                    }
                                    storageKey = @{
                                    href = 'https://vssps.dev.azure.com/organization/_apis/Graph/StorageKeys/vssgp.KZxAEOS5OBwwvtcidMzAKgkPrhLSpJ1SvwQj1CGj72xMmaz6tnXironO0TxMcas9TWir5sbN91JYp90YgbiBcSMcF94FaNmYl1dQSIOMUKPjwFQloaEG4l8rdlvTiSJTEjFxw5QgWrP1'
                                    }
                                }
                                url = 'https://vssps.dev.azure.com/organization/_apis/Graph/Groups/vssgp.KZxAEOS5OBwwvtcidMzAKgkPrhLSpJ1SvwQj1CGj72xMmaz6tnXironO0TxMcas9TWir5sbN91JYp90YgbiBcSMcF94FaNmYl1dQSIOMUKPjwFQloaEG4l8rdlvTiSJTEjFxw5QgWrP1'
                                descriptor = 'vssgp.KZxAEOS5OBwwvtcidMzAKgkPrhLSpJ1SvwQj1CGj72xMmaz6tnXironO0TxMcas9TWir5sbN91JYp90YgbiBcSMcF94FaNmYl1dQSIOMUKPjwFQloaEG4l8rdlvTiSJTEjFxw5QgWrP1'
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
                                subjectKind = 'group'
                                description = 'group3'
                                domain = 'vstfs:///Classification/TeamProject/bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb'
                                principalName = '[team]\\Readers'
                                mailAddress = $null
                                origin = 'vsts'
                                originId = 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb'
                                displayName = 'Readers'
                                _links = @{
                                    self = @{
                                    href = 'https://vssps.dev.azure.com/organization/_apis/Graph/Groups/vssgp.60AL7JP86iP6lpQs2ejp9v8vgpaxLWiiD1GK1zSEDMoHaQnSBunvfc3VixVcMoXlh8omp0yP1lVNAFoLw07MLHhF9aNM8EjsniV0Ok9sniqZj3MoiHWR3vEc4xuYK1T1HnhgxlZVmk0G'
                                    }
                                    memberships = @{
                                    href = 'https://vssps.dev.azure.com/organization/_apis/Graph/Memberships/vssgp.60AL7JP86iP6lpQs2ejp9v8vgpaxLWiiD1GK1zSEDMoHaQnSBunvfc3VixVcMoXlh8omp0yP1lVNAFoLw07MLHhF9aNM8EjsniV0Ok9sniqZj3MoiHWR3vEc4xuYK1T1HnhgxlZVmk0G'
                                    }
                                    membershipState = @{
                                    href = 'https://vssps.dev.azure.com/organization/_apis/Graph/MembershipStates/vssgp.60AL7JP86iP6lpQs2ejp9v8vgpaxLWiiD1GK1zSEDMoHaQnSBunvfc3VixVcMoXlh8omp0yP1lVNAFoLw07MLHhF9aNM8EjsniV0Ok9sniqZj3MoiHWR3vEc4xuYK1T1HnhgxlZVmk0G'
                                    }
                                    storageKey = @{
                                    href = 'https://vssps.dev.azure.com/organization/_apis/Graph/StorageKeys/vssgp.60AL7JP86iP6lpQs2ejp9v8vgpaxLWiiD1GK1zSEDMoHaQnSBunvfc3VixVcMoXlh8omp0yP1lVNAFoLw07MLHhF9aNM8EjsniV0Ok9sniqZj3MoiHWR3vEc4xuYK1T1HnhgxlZVmk0G'
                                    }
                                }
                                url = 'https://vssps.dev.azure.com/organization/_apis/Graph/Groups/vssgp.60AL7JP86iP6lpQs2ejp9v8vgpaxLWiiD1GK1zSEDMoHaQnSBunvfc3VixVcMoXlh8omp0yP1lVNAFoLw07MLHhF9aNM8EjsniV0Ok9sniqZj3MoiHWR3vEc4xuYK1T1HnhgxlZVmk0G'
                                descriptor = 'vssgp.60AL7JP86iP6lpQs2ejp9v8vgpaxLWiiD1GK1zSEDMoHaQnSBunvfc3VixVcMoXlh8omp0yP1lVNAFoLw07MLHhF9aNM8EjsniV0Ok9sniqZj3MoiHWR3vEc4xuYK1T1HnhgxlZVmk0G'
                            }
                        )
                    }
                    StatusCode = 200
                    Headers    = @{}
                }
            }
        }

        It "Returns 3 groups" {
            $result = Get-ADOPSGroup -Organization 'DummyOrg'
            $result | Should -Not -BeNullOrEmpty
            $result | Should -HaveCount 3
        }

        It 'Calls InvokeADOPSRestMethod with the correct query params' {
            Get-ADOPSGroup -Organization 'DummyOrg'
            Should -Invoke InvokeADOPSRestMethod -ModuleName ADOPS -Times 1 -Exactly -ParameterFilter { $Uri -eq "https://vssps.dev.azure.com/DummyOrg/_apis/graph/groups?api-version=7.1-preview.1" }
            Should -Invoke InvokeADOPSRestMethod -ModuleName ADOPS -Times 1 -Exactly -ParameterFilter { $Uri -eq "https://vssps.dev.azure.com/DummyOrg/_apis/graph/groups?continuationToken=page2Token&api-version=7.1-preview.1" }
        }
    }
}