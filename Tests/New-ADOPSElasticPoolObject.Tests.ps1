BeforeDiscovery {
    . $PSScriptRoot\TestHelpers.ps1
    Initialize-TestSetup
}

Describe "New-ADOPSElasticPoolObject" {
    Context "Function tests" {
        It "Function exists" {
            { Get-Command -Name New-ADOPSElasticPoolObject -Module ADOPS -ErrorAction Stop } | Should -Not -Throw
        }

        It 'Has parameter <_>' -TestCases 'ServiceEndpointId', 'ServiceEndpointScope', 'AzureId', 'OsType', 'MaxCapacity', 'DesiredIdle', 'RecycleAfterEachUse', 'DesiredSize', 'AgentInteractiveUI', 'TimeToLiveMinues', 'MaxSavedNodeCount', 'OutputType' {
            (Get-Command -Name New-ADOPSElasticPoolObject).Parameters.Keys | Should -Contain $_
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