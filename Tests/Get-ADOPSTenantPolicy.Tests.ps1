# Pester Tests for Get-ADOPSTenantPolicy
param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}
Describe 'Get-ADOPSTenantPolicy' {

    Context 'Parameters' {
        $TestCases = @(
            @{
                Name      = 'Organization'
                Mandatory = $false
                Type      = 'string'
            },
            @{
                Name      = 'PolicyCategory'
                Mandatory = $false
                Type      = 'string'
            },
            @{
                Name      = 'Force'
                Mandatory = $false
                Type      = 'switch'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases {
            Get-Command Get-ADOPSTenantPolicy | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }

    Context 'Getting RestrictGlobalPersonalAccessToken tenant policy' {
        BeforeAll {
            $OrganizationName = 'DummyOrg'
            $PolicyCategory = 'RestrictGlobalPersonalAccessToken'
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return @'
                {
                    "name": "TenantPolicy.RestrictGlobalPersonalAccessToken",
                    "value": true,
                    "properties": {
                        "AllowedUsersAndGroupObjectIds": "[]"
                    }
                }
'@ | ConvertFrom-Json
            } -ParameterFilter { $Method -eq 'Get' -and $Uri -like '*TenantPolicy/Policies*' }

            Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'DummyOrg' }
        }
        
        It 'uses InvokeADOPSRestMethod single times' {
            Get-ADOPSTenantPolicy -Force -Organization $OrganizationName -PolicyCategory $PolicyCategory
            Should -Invoke 'InvokeADOPSRestMethod' -ModuleName 'ADOPS' -Exactly -Times 1
        }
        It 'should not throw with mandatory parameters' {
            { Get-ADOPSTenantPolicy -Force -Organization $OrganizationName -PolicyCategory $PolicyCategory } | Should -Not -Throw
        }
        It 'should not throw without Organization parameter' {
            { Get-ADOPSTenantPolicy -Force -PolicyCategory $PolicyCategory } | Should -Not -Throw
        }
        It 'returns settings after getting pipelines' {
            (Get-ADOPSTenantPolicy -Force -Organization $OrganizationName -PolicyCategory $PolicyCategory | Get-Member -MemberType NoteProperty).count | Should -Be 3
        }
        
        It 'Should retrieve tenant policy for a valid organization and policy category' {
            # Arrange
            $organization = 'MyOrganization'
            $policyCategory = 'RestrictGlobalPersonalAccessToken'

            # Act
            $result = Get-ADOPSTenantPolicy -Force -Organization $organization -PolicyCategory $policyCategory

            # Assert
            $result | Should -Not -BeNullOrEmpty
            # Additional assertions can be added based on expected output
        }

        It 'Should throw an error for an invalid policy category' {
            # Arrange
            $organization = 'MyOrganization'
            $invalidPolicyCategory = 'InvalidPolicy'

            # Act
            { Get-ADOPSTenantPolicy -Force -Organization $organization -PolicyCategory $invalidPolicyCategory } | Should -Throw
        }
    }

}