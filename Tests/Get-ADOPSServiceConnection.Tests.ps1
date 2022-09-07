param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'Get-ADOPSServiceConnection' {
    Context 'Parameters' {
        $TestCases = @(
            @{
                Name = 'Organization'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'Project'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'Name'
                Mandatory = $false
                Type = 'string'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command Get-ADOPSServiceConnection | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }

    Context 'Command tests' {
        BeforeAll {

            $OrganizationName = 'DummyOrg'
            $Project = 'DummyProject'
            $SCName = 'DummySC1'

            Mock -CommandName GetADOPSHeader -ModuleName ADOPS -MockWith {
                @{
                    Header       = @{
                        'Authorization' = 'Basic Base64=='
                    }
                    Organization = $OrganizationName
                }
            } -ParameterFilter { $OrganizationName -eq $OrganizationName }
            Mock -CommandName GetADOPSHeader -ModuleName ADOPS -MockWith {
                @{
                    Header       = @{
                        'Authorization' = 'Basic Base64=='
                    }
                    Organization = $OrganizationName
                }
            }

            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return @'
                {
                    "value": [
                        {
                            "data": {},
                            "id": "e7a02fa1-ead0-43ea-aeac-d9cbbf844f90",
                            "name": "DummySC1",
                            "type": "azurerm",
                            "url": "https://management.azure.com/",
                            "createdBy": {},
                            "description": "",
                            "authorization": {},
                            "isShared": false,
                            "isReady": true,
                            "operationStatus": {},
                            "owner": "Library",
                            "serviceEndpointProjectReferences": []
                        },
                        {
                            "data": {},
                            "id": "e7a02fa1-ead0-43ea-aeac-d9cbbf844f91",
                            "name": "DummySC2",
                            "type": "azurerm",
                            "url": "https://management.azure.com/",
                            "createdBy": {},
                            "description": "",
                            "authorization": {},
                            "isShared": false,
                            "isReady": true,
                            "operationStatus": {},
                            "owner": "Library",
                            "serviceEndpointProjectReferences": []
                        }
                    ]
                }
'@ | ConvertFrom-Json
            } -ParameterFilter { $Method -eq 'Get' }

        }
        It 'uses InvokeADOPSRestMethod one time.' {
            Get-ADOPSServiceConnection -Organization $OrganizationName -Project $Project -Name $SCName  
            Should -Invoke 'InvokeADOPSRestMethod' -ModuleName 'ADOPS' -Exactly -Times 1
        }
        It 'returns output after getting pipeline' {
            Get-ADOPSServiceConnection -Organization $OrganizationName -Project $Project -Name $SCName | Should -BeOfType [pscustomobject] -Because 'InvokeADOPSRestMethod should convert the json to pscustomobject'
        }
        It 'should not throw without optional parameters' {
            { Get-ADOPSServiceConnection -Project $Project } | Should -Not -Throw
        }
        It 'should throw if connection name does not exist' {
            { Get-ADOPSServiceConnection -Project $Project -Name 'MissingName' } | Should -Throw
        }
        It 'returns single output after getting pipeline' {
            (Get-ADOPSServiceConnection -Organization $OrganizationName -Project $Project -Name $SCName).count | Should -Be 1
        }
        It 'returns multiple outputs after getting pipelines' {
            (Get-ADOPSServiceConnection -Organization $OrganizationName -Project $Project).count | Should -Be 2
        }
    }
}

