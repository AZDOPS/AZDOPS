BeforeDiscovery {
    . $PSScriptRoot\TestHelpers.ps1
    Initialize-TestSetup
}

Describe "New-ADOPSElasticPoolObject" {
    Context 'Parameter validation' {
        It 'Has parameter <_.Name>' -TestCases @(
            @{ Name = 'ServiceEndpointId'; Mandatory = $true }
            @{ Name = 'ServiceEndpointScope'; Mandatory = $true }
            @{ Name = 'AzureId'; Mandatory = $true }
            @{ Name = 'OsType'; }
            @{ Name = 'MaxCapacity'; }
            @{ Name = 'DesiredIdle'; }
            @{ Name = 'RecycleAfterEachUse'; }
            @{ Name = 'DesiredSize'; }
            @{ Name = 'AgentInteractiveUI'; }
            @{ Name = 'TimeToLiveMinues'; }
            @{ Name = 'MaxSavedNodeCount'; }
            @{ Name = 'OutputType'; }
        ) {
            Get-Command -Name New-ADOPSElasticPoolObject | Should -HaveParameterStrict $Name -Mandatory:([bool]$Mandatory) -Type $Type
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