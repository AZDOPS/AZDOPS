param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'New-ADOPSServiceConnection' {
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
                Name      = 'ConnectionData'
                Mandatory = $true
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
            Get-Command New-ADOPSServiceConnection | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }
    
    Context "AzureResourceManagerConnectionArgumentTypes" {
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
                Project          = 'myproj' 
                TenantId         = 'AzureTennantId' 
                SubscriptionName = 'AzureSubscriptionName' 
                SubscriptionId   = 'AzureSubscriptionId' 
            }
        }

        It 'Should not get organization from GetADOPSDefaultOrganization when organization parameter is used' {
            $Splat.Add('ServicePrincipal', [pscredential]::new('User', (ConvertTo-SecureString -String 'PassWord' -AsPlainText -Force)))
            New-ADOPSServiceConnection -Organization 'anotherorg' @Splat
            Should -Invoke GetADOPSDefaultOrganization -ModuleName ADOPS -Times 0 -Exactly
        }

        It 'Should get organization using GetADOPSDefaultOrganization when organization parameter is not used' {
            $Splat.Add('ServicePrincipal', [pscredential]::new('User', (ConvertTo-SecureString -String 'PassWord' -AsPlainText -Force)))
            New-ADOPSServiceConnection @Splat
            Should -Invoke GetADOPSDefaultOrganization -ModuleName ADOPS -Times 1 -Exactly
        }

        It 'Verifying URI is correct' {
            $Splat.Add('ServicePrincipal', [pscredential]::new('User', (ConvertTo-SecureString -String 'PassWord' -AsPlainText -Force)))
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith { return $URI }
            $r = New-ADOPSServiceConnection @Splat
            $r | Should -Be 'https://dev.azure.com/myorg/myproj/_apis/serviceendpoint/endpoints?api-version=7.2-preview.4'
        }

        It 'Verifying body is correct - ServicePrincipal' {
            $Splat.Add('ServicePrincipal', [pscredential]::new('User', (ConvertTo-SecureString -String 'PassWord' -AsPlainText -Force)))
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith { return $body }
            $r = New-ADOPSServiceConnection @Splat | ConvertFrom-Json | ConvertTo-Json -Compress -Depth 10
            $r | Should -Be '{"name":"AzureSubscriptionName","description":"","type":"AzureRM","url":"https://management.azure.com/","data":{"subscriptionId":"AzureSubscriptionId","subscriptionName":"AzureSubscriptionName","environment":"AzureCloud","scopeLevel":"Subscription","creationMode":"Manual"},"authorization":{"parameters":{"tenantid":"AzureTennantId","serviceprincipalid":"User","authenticationType":"spnKey","serviceprincipalkey":"PassWord"},"scheme":"ServicePrincipal"},"isShared":false,"isReady":true,"serviceEndpointProjectReferences":[{"projectReference":{"id":"ProjectInfoId","name":"myproj"},"name":"AzureSubscriptionName"}]}'
        }

        It 'Verifying body is correct - ManagedServiceIdentity' {
            $Splat.Add('ServicePrincipal', [pscredential]::new('User', (ConvertTo-SecureString -String 'PassWord' -AsPlainText -Force)))
            $Splat.Add('ManagedIdentity', $true)
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith { return $body }
            $r = New-ADOPSServiceConnection @Splat | ConvertFrom-Json | ConvertTo-Json -Compress -Depth 10
            $r | Should -Be '{"name":"AzureSubscriptionName","description":"","type":"AzureRM","url":"https://management.azure.com/","data":{"subscriptionId":"AzureSubscriptionId","subscriptionName":"AzureSubscriptionName","environment":"AzureCloud","scopeLevel":"Subscription"},"authorization":{"parameters":{"tenantid":"AzureTennantId","serviceprincipalid":"User","serviceprincipalkey":"PassWord"},"scheme":"ManagedServiceIdentity"},"isShared":false,"isReady":true,"serviceEndpointProjectReferences":[{"projectReference":{"id":"ProjectInfoId","name":"myproj"},"name":"AzureSubscriptionName"}]}'
        }

        It 'Verifying body is correct - WorkloadIdentityFederation' {
            $Splat.Add('WorkloadIdentityFederation', $true)
            $Splat.Add('AzureScope', 'Azure/Scope')
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith { return $body }
            $r = New-ADOPSServiceConnection @Splat | ConvertFrom-Json | ConvertTo-Json -Compress -Depth 10
            $r | Should -Be '{"name":"AzureSubscriptionName","description":"","type":"AzureRM","url":"https://management.azure.com/","data":{"subscriptionId":"AzureSubscriptionId","subscriptionName":"AzureSubscriptionName","environment":"AzureCloud","scopeLevel":"Subscription","creationMode":"Automatic"},"authorization":{"parameters":{"tenantid":"AzureTennantId","scope":"Azure/Scope"},"scheme":"WorkloadIdentityFederation"},"isShared":false,"isReady":true,"serviceEndpointProjectReferences":[{"projectReference":{"id":"ProjectInfoId","name":"myproj"},"name":"AzureSubscriptionName"}]}'
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
                                id   = "/43cf98ab-e228-451f-b0b1-05008d45460d"
                                name = "myProject"
                            }
                            name             = "myNewServiceEndpoint"
                        }            
                    )
                }
            }
        }

        It 'Should not get organization from GetADOPSDefaultOrganization when organization parameter is used' {
            New-ADOPSServiceConnection -Organization 'anotherorg' @Splat
            Should -Invoke GetADOPSDefaultOrganization -ModuleName ADOPS -Times 0 -Exactly
        }

        It 'Should get organization using GetADOPSDefaultOrganization when organization parameter is not used' {
            New-ADOPSServiceConnection @Splat
            Should -Invoke GetADOPSDefaultOrganization -ModuleName ADOPS -Times 1 -Exactly
        }

        It 'Verifying URI is correct' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith { return $URI }
            $r = New-ADOPSServiceConnection @Splat
            $r | Should -Be 'https://dev.azure.com/myorg/_apis/serviceendpoint/endpoints?api-version=7.2-preview.4'
        }

        It 'Verifying body is correct - GenericServiceConnection' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS `
                -ParameterFilter { $Uri -like "*_apis/serviceendpoint/endpoints*" } `
                -MockWith { return $body }

            $r = New-ADOPSServiceConnection @Splat | ConvertFrom-Json | ConvertTo-Json -Depth 10 -Compress
            $r | Should -Be '{"type":"dockerregistry","name":"Service Connection Name","description":"Service Connection Description","authorization":{"paramaters":{"registry":"dockerregistry.local","username":"pipeline","password":"supersecretpassword","email":"admin@dockerregistry.local"},"scheme":"UsernamePassword"},"isSshared":false,"isReady":true,"owner":"Library","serviceEndpointProjectReferences":[{"projectReference":{"id":"/43cf98ab-e228-451f-b0b1-05008d45460d","name":"myProject"},"name":"myNewServiceEndpoint"}]}'
        }
    }
}

