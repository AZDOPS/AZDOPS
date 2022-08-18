Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot\..\Source\ADOPS -Force

Describe "New-ADOPSElasticPoolObject" {
    Context "Parameters" {
        $TestCases = @(
            @{
                Name = 'ServiceEndpointId'
                Mandatory = $true
                Type = 'guid'
            },
            @{
                Name = 'ServiceEndpointScope'
                Mandatory = $true
                Type = 'guid'
            },
            @{
                Name = 'AzureId'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'OsType'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'MaxCapacity'
                Mandatory = $false
                Type = 'int'
            },
            @{
                Name = 'DesiredIdle'
                Mandatory = $false
                Type = 'int'
            },
            @{
                Name = 'RecycleAfterEachUse'
                Mandatory = $false
                Type = 'bool'
            },
            @{
                Name = 'DesiredSize'
                Mandatory = $false
                Type = 'int'
            },
            @{
                Name = 'AgentInteractiveUI'
                Mandatory = $false
                Type = 'bool'
            },
            @{
                Name = 'TimeToLiveMinues'
                Mandatory = $false
                Type = 'int'
            },
            @{
                Name = 'MaxSavedNodeCount'
                Mandatory = $false
                Type = 'int'
            },
            @{
                Name = 'OutputType'
                Mandatory = $false
                Type = 'string'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command New-ADOPSElasticPoolObject | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }

    Context "Function returns created elastic pool" {

        It "Returns an output" {
            New-ADOPSElasticPoolObject -ServiceEndpointId '44868479-e856-42bf-9a2b-74bb500d8e36' -ServiceEndpointScope 'a36adc0c-a513-4acd-85bf-2c2a7bb62d30' -AzureId '/subscriptions/6713962a-bebb-45c2-97cd-fb0dead95acf/resourceGroups/resourceGroupName/providers/Microsoft.Compute/virtualMachineScaleSets/vmss-test' | Should -Not -BeNullOrEmpty
        }

        It "Returns a PowerShell object" {
            (New-ADOPSElasticPoolObject -ServiceEndpointId '44868479-e856-42bf-9a2b-74bb500d8e36' -ServiceEndpointScope 'a36adc0c-a513-4acd-85bf-2c2a7bb62d30' -AzureId '/subscriptions/6713962a-bebb-45c2-97cd-fb0dead95acf/resourceGroups/resourceGroupName/providers/Microsoft.Compute/virtualMachineScaleSets/vmss-test' -OutputType 'pscustomobject').GetType().FullName | Should -Be 'System.Management.Automation.PSCustomObject'
        }

        It "Returns the given AzureId" {
            (New-ADOPSElasticPoolObject -ServiceEndpointId '44868479-e856-42bf-9a2b-74bb500d8e36' -ServiceEndpointScope 'a36adc0c-a513-4acd-85bf-2c2a7bb62d30' -AzureId '/subscriptions/6713962a-bebb-45c2-97cd-fb0dead95acf/resourceGroups/resourceGroupName/providers/Microsoft.Compute/virtualMachineScaleSets/vmss-test').azureId | Should -Be '/subscriptions/6713962a-bebb-45c2-97cd-fb0dead95acf/resourceGroups/resourceGroupName/providers/Microsoft.Compute/virtualMachineScaleSets/vmss-test'
        }

        It "Returns a Json object/string" {
            (New-ADOPSElasticPoolObject -ServiceEndpointId '44868479-e856-42bf-9a2b-74bb500d8e36' -ServiceEndpointScope 'a36adc0c-a513-4acd-85bf-2c2a7bb62d30' -AzureId '/subscriptions/6713962a-bebb-45c2-97cd-fb0dead95acf/resourceGroups/resourceGroupName/providers/Microsoft.Compute/virtualMachineScaleSets/vmss-test' -OutputType 'json').GetType().FullName | Should -Be 'System.String'
        }

    }
}