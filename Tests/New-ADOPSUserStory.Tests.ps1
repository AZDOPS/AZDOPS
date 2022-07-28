BeforeDiscovery {
    . $PSScriptRoot\TestHelpers.ps1
    Initialize-TestSetup
}

Describe 'New-ADOPSUserStory' {
    Context 'Parameter validation' {
        It 'Has parameter <_.Name>' -TestCases @(
            @{ Name = 'Title'; Mandatory = $true }
            @{ Name = 'ProjectName'; Mandatory = $true }
            @{ Name = 'Description'; }
            @{ Name = 'Tags'; }
            @{ Name = 'Priority'; }
            @{ Name = 'Organization'; }
        ) {
            Get-Command -Name New-ADOPSUserStory | Should -HaveParameterStrict $Name -Mandatory:([bool]$Mandatory) -Type $Type
        }
    }

    Context 'Creating new user story' {
        BeforeAll {
            InModuleScope -ModuleName ADOPS {
                Mock -CommandName GetADOPSHeader -ModuleName ADOPS -MockWith {
                    @{
                        Header       = @{
                            'Authorization' = 'Basic Base64=='
                        }
                        Organization = $OrganizationName
                    }
                } -ParameterFilter { $OrganizationName -eq 'Organization' }
                Mock -CommandName GetADOPSHeader -ModuleName ADOPS -MockWith {
                    @{
                        Header       = @{
                            'Authorization' = 'Basic Base64=='
                        }
                        Organization = 'DummyOrg'
                    }
                }

                Mock -CommandName InvokeADOPSRestMethod -MockWith {
                    return $InvokeSplat
                }
            }

            $TestRunSplat = @{
                Organization = 'DummyOrg'
                ProjectName = 'DummyProj'
                Title = 'USTitle'
                Description = 'USDescription'
                Tags = 'USTags'
                Priority = 'USPrio'
            }
        }

        It 'Should have called mock InvokeADOPSRestMethod' {
            $TesRes = New-ADOPSUserStory @TestRunSplat
            Should -Invoke -CommandName 'InvokeADOPSRestMethod' -Exactly 1 -ModuleName ADOPS
        }
        It 'Should have called mock GetADOPSHeader' {
            $TesRes = New-ADOPSUserStory @TestRunSplat
            Should -Invoke -CommandName 'GetADOPSHeader' -Exactly 1 -ModuleName ADOPS
        }

        It 'Verifying post object, ContentType' {
            $TesRes = New-ADOPSUserStory @TestRunSplat
            $TesRes.ContentType | Should -Be "application/json-patch+json"
        }
        It 'Verifying post object, Body' {
            $DesiredReslt = '[{"op":"add","path":"/fields/System.Title","value":"USTitle"},{"op":"add","path":"/fields/System.Description","value":"USDescription"},{"op":"add","path":"/fields/System.Tags","value":"USTags"},{"op":"add","path":"/fields/Microsoft.VSTS.Common.Priority","value":"USPrio"}]'
            $TesRes = (New-ADOPSUserStory @TestRunSplat).Body | ConvertFrom-Json | ConvertTo-Json -Compress
            $TesRes | Should -Be $DesiredReslt
        }
    }
}