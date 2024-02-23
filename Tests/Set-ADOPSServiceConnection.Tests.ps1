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
                Name      = 'Organization'
                Mandatory = $false
                Type      = 'string'
            },
            @{
                Name      = 'TenantId'
                Mandatory = $true
                Type      = 'string'
            },
            @{
                Name      = 'SubscriptionName'
                Mandatory = $true
                Type      = 'string'
            },
            @{
                Name      = 'SubscriptionId'
                Mandatory = $true
                Type      = 'string'
            },
            @{
                Name      = 'Project'
                Mandatory = $true
                Type      = 'string'
            },
            @{
                Name      = 'ConnectionName'
                Mandatory = $false
                Type      = 'string'
            },
            @{
                Name      = 'Description'
                Mandatory = $false
                Type      = 'string'
            },
            @{
                Name      = 'ServicePrincipal'
                Mandatory = $true
                Type      = 'pscredential'
            },
            @{
                Name      = 'ManagedIdentity'
                Mandatory = $true
                Type      = 'switch'
            },
            @{
                Name      = 'ServiceEndpointId'
                Mandatory = $true
                Type      = 'guid'
            },
            @{
                Name      = 'EndpointOperation'
                Mandatory = $false
                Type      = 'string'
            },
            @{
                Name      = 'WorkloadIdentityFederation'
                Mandatory = $true
                Type      = 'switch'
            },
            @{
                Name      = 'AzureScope'
                Mandatory = $true
                Type      = 'string'
            }
            
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases {
            Get-Command Set-ADOPSServiceConnection | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }
    
    Context "AzureResourceManagerConnection" {
        BeforeAll {
            Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'DummyOrg' }
            
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {}

            Mock -CommandName Get-ADOPSProject -ModuleName ADOPS -MockWith {
                @{
                    id = 'ProjectInfoId'
                }
            }
        }

        BeforeEach {
            $Splat = @{
                Project           = 'myproj' 
                TenantId          = 'AzureTennantId' 
                SubscriptionName  = 'AzureSubscriptionName' 
                SubscriptionId    = 'AzureSubscriptionId' 
                ServiceEndpointId = '8bce170f-ac4e-4164-a7d7-6cbc8f69f6af'
            }
        }
        
        It 'Should not get organization from GetADOPSDefaultOrganization when organization parameter is used' {
            $Splat.Add('ServicePrincipal', [pscredential]::new('User', (ConvertTo-SecureString -String 'PassWord' -AsPlainText -Force)))
            Set-ADOPSServiceConnection -Organization 'anotherorg' @Splat
            Should -Invoke GetADOPSDefaultOrganization -ModuleName ADOPS -Times 0 -Exactly
        }

        It 'Should get organization using GetADOPSDefaultOrganization when organization parameter is not used' {
            $Splat.Add('ServicePrincipal', [pscredential]::new('User', (ConvertTo-SecureString -String 'PassWord' -AsPlainText -Force)))
            Set-ADOPSServiceConnection @Splat
            Should -Invoke GetADOPSDefaultOrganization -ModuleName ADOPS -Times 1 -Exactly
        }

        It 'Verifying URI is correct' {
            $Splat.Add('ServicePrincipal', [pscredential]::new('User', (ConvertTo-SecureString -String 'PassWord' -AsPlainText -Force)))
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith { return $URI }
            $r = Set-ADOPSServiceConnection @Splat
            $r | Should -Be 'https://dev.azure.com/DummyOrg/_apis/serviceendpoint/endpoints/8bce170f-ac4e-4164-a7d7-6cbc8f69f6af?api-version=7.1-preview.4'
        }

        It 'Verifying URI is correct with EndpointOperation' {
            $Splat.Add('ServicePrincipal', [pscredential]::new('User', (ConvertTo-SecureString -String 'PassWord' -AsPlainText -Force)))
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS `
                -ParameterFilter { $Method -eq "PUT" } `
                -MockWith { return $URI }
            $r = Set-ADOPSServiceConnection @Splat -EndpointOperation "noop"
            $r | Should -Be 'https://dev.azure.com/DummyOrg/_apis/serviceendpoint/endpoints/8bce170f-ac4e-4164-a7d7-6cbc8f69f6af?operation=noop&api-version=7.1-preview.4'
        }

        It 'Verifying body is correct - ServicePrincipal' {
            $Splat.Add('ServicePrincipal', [pscredential]::new('User', (ConvertTo-SecureString -String 'PassWord' -AsPlainText -Force)))
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS `
                -ParameterFilter { $Method -eq "PUT" } `
                -MockWith { return $body }
            $r = Set-ADOPSServiceConnection @Splat | ConvertFrom-Json | ConvertTo-Json -Compress -Depth 10
            $r | Should -Be '{"id":"8bce170f-ac4e-4164-a7d7-6cbc8f69f6af","name":"AzureSubscriptionName","description":"","type":"AzureRM","url":"https://management.azure.com/","data":{"subscriptionId":"AzureSubscriptionId","subscriptionName":"AzureSubscriptionName","environment":"AzureCloud","scopeLevel":"Subscription","creationMode":"Manual"},"authorization":{"parameters":{"tenantid":"AzureTennantId","serviceprincipalid":"User","authenticationType":"spnKey","serviceprincipalkey":"PassWord"},"scheme":"ServicePrincipal"},"isShared":false,"isReady":true,"serviceEndpointProjectReferences":[{"projectReference":{"id":"ProjectInfoId","name":"myproj"},"name":"AzureSubscriptionName"}]}'
        }

        It 'Verifying body is correct - ManagedServiceIdentity' {
            $Splat.Add('ServicePrincipal', [pscredential]::new('User', (ConvertTo-SecureString -String 'PassWord' -AsPlainText -Force)))
            $Splat.Add('ManagedIdentity', $true)
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith { return $body }
            $r = Set-ADOPSServiceConnection @Splat | ConvertFrom-Json | ConvertTo-Json -Compress -Depth 10
            $r | Should -Be '{"id":"8bce170f-ac4e-4164-a7d7-6cbc8f69f6af","name":"AzureSubscriptionName","description":"","type":"AzureRM","url":"https://management.azure.com/","data":{"subscriptionId":"AzureSubscriptionId","subscriptionName":"AzureSubscriptionName","environment":"AzureCloud","scopeLevel":"Subscription"},"authorization":{"parameters":{"tenantid":"AzureTennantId","serviceprincipalid":"User","serviceprincipalkey":"PassWord"},"scheme":"ManagedServiceIdentity"},"isShared":false,"isReady":true,"serviceEndpointProjectReferences":[{"projectReference":{"id":"ProjectInfoId","name":"myproj"},"name":"AzureSubscriptionName"}]}'
        }

        It 'Verifying body is correct - WorkloadIdentityFederation' {
            $Splat.Add('WorkloadIdentityFederation', $true)
            $Splat.Add('AzureScope', 'Azure/Scope')
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith { return $body }
            $r = Set-ADOPSServiceConnection @Splat | ConvertFrom-Json | ConvertTo-Json -Compress -Depth 10
            $r | Should -Be '{"id":"8bce170f-ac4e-4164-a7d7-6cbc8f69f6af","name":"AzureSubscriptionName","description":"","type":"AzureRM","url":"https://management.azure.com/","data":{"subscriptionId":"AzureSubscriptionId","subscriptionName":"AzureSubscriptionName","environment":"AzureCloud","scopeLevel":"Subscription","creationMode":"Automatic"},"authorization":{"parameters":{"tenantid":"AzureTennantId","scope":"Azure/Scope"},"scheme":"WorkloadIdentityFederation"},"isShared":false,"isReady":true,"serviceEndpointProjectReferences":[{"projectReference":{"id":"ProjectInfoId","name":"myproj"},"name":"AzureSubscriptionName"}]}'
        }
    }

    Context "GenericServiceConnection" {
        BeforeAll {
            Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'myorg' }
            
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {}
    
            Mock -CommandName Get-ADOPSProject -ModuleName ADOPS -MockWith {
                @{
                    id = 'ProjectInfoId'
                }
            }
        }
        
        BeforeEach {
            $Splat = @{
                ConnectionData = [ordered]@{
                    id                               = '8bce170f-ac4e-4164-a7d7-6cbc8f69f6af'
                    type                             = "dockerregistry"
                    name                             = "Service Connection Name"
                    description                      = "Service Connection Description"
                    authorization                    = [ordered]@{
                        paramaters = [ordered]@{
                            registry = "dockerregistry.local"
                            username = "pipeline"
                            password = "supersecretpassword"
                            email    = "admin@dockerregistry.local"
                        }
                        scheme     = "UsernamePassword"
                    }
                    isSshared                        = $false
                    isReady                          = $true
                    owner                            = "Library"
                    serviceEndpointProjectReferences = @(
                        [ordered]@{
                            projectReference = [ordered]@{
                                id   = "43cf98ab-e228-451f-b0b1-05008d45460d"
                                name = "myProject"
                            }
                            name             = "myNewServiceEndpoint"
                        }            
                    )
                }
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

        It 'Verifying URI is correct' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS `
                -ParameterFilter { $Method -eq "PUT" } `
                -MockWith { return $URI }

            $r = Set-ADOPSServiceConnection @Splat
            $r | Should -Be 'https://dev.azure.com/myorg/_apis/serviceendpoint/endpoints/8bce170f-ac4e-4164-a7d7-6cbc8f69f6af?api-version=7.1-preview.4'
        }

        It 'Verifying URI is correct with EndpointOperation' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS `
                -ParameterFilter { ($Method -eq "PUT") } `
                -MockWith { return $URI }
            $r = Set-ADOPSServiceConnection @Splat -EndpointOperation "noop"
            $r | Should -Be 'https://dev.azure.com/myorg/_apis/serviceendpoint/endpoints/8bce170f-ac4e-4164-a7d7-6cbc8f69f6af?operation=noop&api-version=7.1-preview.4'
        }

        It 'Verifying body is correct - GenericServiceConnection' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS `
                -ParameterFilter { ($Method -eq "PUT") -and ($Uri -like "*_apis/serviceendpoint/endpoints*") } `
                -MockWith { return $body }
    
            $r = Set-ADOPSServiceConnection @Splat | ConvertFrom-Json | ConvertTo-Json -Depth 10 -Compress
            $r | Should -Be '{"id":"8bce170f-ac4e-4164-a7d7-6cbc8f69f6af","type":"dockerregistry","name":"Service Connection Name","description":"Service Connection Description","authorization":{"paramaters":{"registry":"dockerregistry.local","username":"pipeline","password":"supersecretpassword","email":"admin@dockerregistry.local"},"scheme":"UsernamePassword"},"isSshared":false,"isReady":true,"owner":"Library","serviceEndpointProjectReferences":[{"projectReference":{"id":"43cf98ab-e228-451f-b0b1-05008d45460d","name":"myProject"},"name":"myNewServiceEndpoint"}]}'
        }
    }

}
