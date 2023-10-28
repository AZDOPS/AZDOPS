param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
    
    BeforeAll {
        Mock -ModuleName ADOPS -CommandName GetADOPSConfigFile {
            @{ 'Default' = @{ 'Identity' = 'dummyuser'; 'TenantId' = 'dummytenant'; 'Organization' = 'org1' } }
        }
        Mock -ModuleName ADOPS SetADOPSConfigFile -MockWith { }
    }
}

Describe 'Connect-ADOPS' {
    Context 'Parameters' {
        $TestCases = @(
            @{
                Name      = 'Organization'
                Mandatory = $true
                Type      = 'string'
            },
            @{
                Name      = 'TenantId'
                Mandatory = $false
                Type      = 'string'
            },
            @{
                Name      = 'Interactive'
                Mandatory = $false
                Type      = 'System.Management.Automation.SwitchParameter'
            },
            @{
                Name      = 'ManagedIdentity'
                Mandatory = $true
                Type      = 'System.Management.Automation.SwitchParameter'
            },
            @{
                Name      = 'OAuthToken'
                Mandatory = $true
                Type      = 'string'
            }
        )
        
        It 'Should have parameter <_.Name>' -TestCases $TestCases {
            Get-Command Connect-ADOPS | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }
    
    Context 'Error handling' {
        It 'Should throw if InvokeADOPSRestMethod returns error.' {
            Mock -CommandName InvokeADOPSRestMethod -MockWith { throw 'DummyError' } -ModuleName ADOPS
            
            { Connect-ADOPS -OAuthToken 'MyTokenGoesHere' -Organization 'MyOrg' } | Should -Throw
        }
    }

    Context 'Initial connection, No previous connection created' {
        BeforeAll {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                @{
                    'displayName'  = 'DummyUser'
                    'publicAlias'  = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'
                    'emailAddress' = 'dummyuser@domain.com'
                    'coreRevision' = '999999999'
                    'timeStamp'    = '2022-01-01T12:00:00+02:00'
                    'id'           = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'
                    'revision'     = '999999999'
                }
            }
            Mock -ModuleName ADOPS GetADOPSOrganizationAccess -MockWith {
                'MyOrg1'
                'MyOrg2'
            }
            Mock -CommandName Get-AzToken -ModuleName ADOPS -MockWith {
                @{
                    'Token'    = 'eyJ0eXAiOiLoremIpsum'
                    'Identity' = 'DummyUser'
                    'TenantId' = 'DummyTenant' 
                }
            }
        }
        
        It 'Should parse organization from Azure DevOps Service url' {
            Mock -ModuleName ADOPS SetADOPSConfigFile
            Connect-ADOPS -OAuthToken 'MyTokenGoesHere' -Organization 'https://dev.azure.com/MyOrg1/'
            Should -Invoke SetADOPSConfigFile -Times 1 -Exactly -ModuleName ADOPS -ParameterFilter { $ConfigObject['Default']['Organization'] -eq "MyOrg1" }
        }

        It 'Should not call Get-AzToken when OAuthToken is provided' {
            Connect-ADOPS -OAuthToken 'MyTokenGoesHere' -Organization 'MyOrg1'
            Should -Invoke Get-AzToken -Times 0 -Exactly -ModuleName ADOPS
        }

        It 'Should not throw if token has access to provided organization' {
            { Connect-ADOPS -OAuthToken 'MyTokenGoesHere' -Organization 'MyOrg2' } | Should -Not -Throw
        }

        It 'Should throw if token does not have access to provided organization' {
            { Connect-ADOPS -OAuthToken 'MyTokenGoesHere' -Organization 'MyOrg3' } | Should -Throw
        }
    }
}