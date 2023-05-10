param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'Set-ADOPSServiceConnection' {
    Context 'Parameters' {
        $TestCases = @(
            @{
                Name = 'Organization'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'TenantId'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'SubscriptionName'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'SubscriptionId'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'Project'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'ConnectionName'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'ServicePrincipal'
                Mandatory = $true
                Type = 'pscredential'
            },
            @{
                Name = 'ManagedIdentity'
                Mandatory = $true
                Type = 'switch'
            },
            @{
                Name = 'ServiceEndpointId'
                Mandatory = $true
                Type = 'guid'
            },@{
                Name = 'EndpointOperation'
                Mandatory = $false
                Type = 'string'
            }
            
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command Set-ADOPSServiceConnection | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }
    
    Context "Functionality" {
        BeforeAll {
            Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'DummyOrg' }
            
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {}

            Mock -CommandName Get-ADOPSProject -ModuleName ADOPS -MockWith {
                @{
                    id = 'ProjectInfoId'
                }
            }
            
            $Splat = @{
                Project = 'myproj' 
                TenantId = 'AzureTennantId' 
                SubscriptionName = 'AzureSubscriptionName' 
                SubscriptionId = 'AzureSubscriptionId' 
                ServiceEndpointId = '8bce170f-ac4e-4164-a7d7-6cbc8f69f6af'
                ServicePrincipal = [pscredential]::new('User', (ConvertTo-SecureString -String 'PassWord' -AsPlainText -Force))
            }
        }
        
        It 'Should not get organization from GetADOPSDefaultOrganization when organization parameter is used' {
            Set-ADOPSServiceConnection -Organization 'anotherorg' @Splat
            Should -Invoke GetADOPSDefaultOrganization -ModuleName ADOPS -Times 0 -Exactly
        }

        It 'Should get organization using GetADOPSDefaultOrganization when organization parameter is not used' {
            Set-ADOPSServiceConnection @Splat
            Should -Invoke GetADOPSDefaultOrganization -ModuleName ADOPS -Times 1 -Exactly
        }
    }
}