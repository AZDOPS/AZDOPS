BeforeDiscovery {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSScriptRoot\..\Source\ADOPS -Force
}

Describe 'New-ADOPSServiceConnection' {
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
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command New-ADOPSServiceConnection | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }

    
    Context "Functionality" {
        BeforeAll {
            Mock GetADOPSHeader -ModuleName ADOPS -MockWith {
                @{
                    Organization = "myorg"
                }
            }
            Mock GetADOPSHeader -ModuleName ADOPS -ParameterFilter { $Organization -eq 'anotherorg' } -MockWith {
                @{
                    Organization = "anotherOrg"
                }
            }
            
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {}

            Mock -CommandName Get-ADOPSProject -ModuleName ADOPS -MockWith {
                @{
                    id = 'ProjectInfoId'
                }
            }
        }
        
        BeforeEach {
            $Splat = @{
                Project = 'myproj' 
                TenantId = 'AzureTennantId' 
                SubscriptionName = 'AzureSubscriptionName' 
                SubscriptionId = 'AzureSubscriptionId' 
                ServicePrincipal = [pscredential]::new('User', (ConvertTo-SecureString -String 'PassWord' -AsPlainText -Force))
            }
        }

        It 'Should get organization from GetADOPSHeader when organization parameter is used' {
            New-ADOPSServiceConnection -Organization 'anotherorg' @Splat
            Should -Invoke GetADOPSHeader -ModuleName ADOPS -ParameterFilter { $Organization -eq 'anotherorg' } -Times 1 -Exactly
        }

        It 'Should validate organization using GetADOPSHeader when organization parameter is not used' {
            New-ADOPSServiceConnection @Splat
            Should -Invoke GetADOPSHeader -ModuleName ADOPS -ParameterFilter { $Organization -eq 'anotherorg' } -Times 0 -Exactly
            Should -Invoke GetADOPSHeader -ModuleName ADOPS -Times 1 -Exactly
        }

        It 'Verifying URI is correct' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith { return $URI}
            $r = New-ADOPSServiceConnection @Splat
            $r | Should -Be 'https://dev.azure.com/myorg/myproj/_apis/serviceendpoint/endpoints?api-version=6.0-preview.4'
        }

        It 'Verifying body is correct' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith { return $body}
            $r = New-ADOPSServiceConnection @Splat | ConvertFrom-Json | ConvertTo-Json -Compress -Depth 10
            $r | Should -Be '{"serviceEndpointProjectReferences":[{"name":"AzureSubscriptionName","projectReference":{"name":"myproj","id":"ProjectInfoId"}}],"isShared":false,"data":{"subscriptionName":"AzureSubscriptionName","environment":"AzureCloud","creationMode":"Manual","scopeLevel":"Subscription","subscriptionId":"AzureSubscriptionId"},"url":"https://management.azure.com/","authorization":{"scheme":"ServicePrincipal","parameters":{"tenantid":"AzureTennantId","authenticationType":"spnKey","serviceprincipalkey":"PassWord","serviceprincipalid":"User"}},"type":"AzureRM","name":"AzureSubscriptionName","isReady":true}'
        }
    }
}

