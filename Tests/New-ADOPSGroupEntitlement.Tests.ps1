param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'New-ADOPSGroupEntitlement' {
    Context 'Parameters' {
        $TestCases = @(
            @{
                Name = 'GroupOriginId'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'LicensingSource'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'AccountLicenseType'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'ProjectGroupType'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'ProjectId'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'Organization'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'Wait'
                Mandatory = $false
                Type = 'switch'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases {
            Get-Command New-ADOPSGroupEntitlement | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }

    Context 'Adding group entitlement' {
        BeforeEach {
            Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'myorg' }
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $InvokeSplat
            } -ParameterFilter { $Method -eq 'Post' }
        }

        BeforeAll {
            $script:testOrgName = 'DummyOrg'
            $script:testGroupId = '01d0472d-9949-421e-81d8-fcb5668a394d'
            $script:testProjectId = '8130f18e-f65b-431d-a777-5d4a6f3468ba'
        }

        It 'uses InvokeADOPSRestMethod once without wait parameter' {
            New-ADOPSGroupEntitlement -Organization $testOrgName -GroupOriginId $testGroupId -ProjectId $testProjectId -AccountLicenseType 'Express' -ProjectGroupType 'projectContributor'
            Should -Invoke 'InvokeADOPSRestMethod' -ModuleName 'ADOPS' -Exactly -Times 1
        }

        It 'should throw with missing GroupOriginId parameter' {
            { New-ADOPSGroupEntitlement -ProjectId $testProjectId -AccountLicenseType 'Express' -ProjectGroupType 'projectContributor' } | Should -Throw
        }

        It 'should throw with missing AccountLicenseType parameter' {
            { New-ADOPSGroupEntitlement -GroupOriginId $testGroupId -ProjectId $testProjectId -ProjectGroupType 'projectContributor' } | Should -Throw
        }

        It 'should throw with missing ProjectGroupType parameter' {
            { New-ADOPSGroupEntitlement -GroupOriginId $testGroupId -ProjectId $testProjectId -AccountLicenseType 'Express' } | Should -Throw
        }

        It 'should throw with missing ProjectId parameter' {
            { New-ADOPSGroupEntitlement -GroupOriginId $testGroupId -AccountLicenseType 'Express' -ProjectGroupType 'projectContributor' } | Should -Throw
        }

        It 'should throw with invalid AccountLicenseType parameter' {
            { New-ADOPSGroupEntitlement -GroupOriginId $testGroupId -ProjectId $testProjectId -AccountLicenseType 'Invalid' -ProjectGroupType 'projectContributor' } | Should -Throw
        }

        It 'should throw with invalid ProjectGroupType parameter' {
            { New-ADOPSGroupEntitlement -GroupOriginId $testGroupId -ProjectId $testProjectId -AccountLicenseType 'Express' -ProjectGroupType 'Invalid' } | Should -Throw
        }

        It 'should not throw with all mandatory parameters' {
            { New-ADOPSGroupEntitlement -GroupOriginId $testGroupId -ProjectId $testProjectId -AccountLicenseType 'Express' -ProjectGroupType 'projectContributor' } | Should -Not -Throw
        }

        It 'Verify uri' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                return $uri
            } -ParameterFilter { $Method -eq 'Post' }

            $result = New-ADOPSGroupEntitlement -Organization $testOrgName -GroupOriginId $testGroupId -ProjectId $testProjectId
            $result.OriginalString | Should -Be "https://vsaex.dev.azure.com/$testOrgName/_apis/GroupEntitlements?api-version=7.1"
        }
    }
}