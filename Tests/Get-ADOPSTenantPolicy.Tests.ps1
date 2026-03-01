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

    Context 'Getting a specific tenant policy category' {
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

        It 'should not throw' {
            { Get-ADOPSTenantPolicy -Force -Organization $OrganizationName -PolicyCategory $PolicyCategory } | Should -Not -Throw
        }
        It 'should not throw without Organization parameter' {
            { Get-ADOPSTenantPolicy -Force -PolicyCategory $PolicyCategory } | Should -Not -Throw
        }
        It 'calls InvokeADOPSRestMethod exactly once' {
            Get-ADOPSTenantPolicy -Force -Organization $OrganizationName -PolicyCategory $PolicyCategory
            Should -Invoke 'InvokeADOPSRestMethod' -ModuleName 'ADOPS' -Exactly -Times 1
        }
        It 'returns tenant policy settings' {
            (Get-ADOPSTenantPolicy -Force -Organization $OrganizationName -PolicyCategory $PolicyCategory | Get-Member -MemberType NoteProperty).Count | Should -Be 3
        }
    }

    Context 'Getting all tenant policy categories' {
        BeforeAll {
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

        It 'should not throw' {
            { Get-ADOPSTenantPolicy -Force -Organization 'DummyOrg' } | Should -Not -Throw
        }
        It 'calls InvokeADOPSRestMethod exactly 5 times' {
            Get-ADOPSTenantPolicy -Force -Organization 'DummyOrg'
            Should -Invoke 'InvokeADOPSRestMethod' -ModuleName 'ADOPS' -Exactly -Times 5
        }
    }

    Context 'When insecure APIs are not enabled and -Force is not used' {
        BeforeAll {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {}
            Mock -CommandName Write-Verbose -ModuleName ADOPS -MockWith {}
        }

        It 'should not throw' {
            { Get-ADOPSTenantPolicy -Organization 'DummyOrg' } | Should -Not -Throw
        }
        It 'should not call InvokeADOPSRestMethod' {
            Get-ADOPSTenantPolicy -Organization 'DummyOrg'
            Should -Not -Invoke 'InvokeADOPSRestMethod' -ModuleName 'ADOPS'
        }
        It 'should write a verbose warning' {
            Get-ADOPSTenantPolicy -Organization 'DummyOrg'
            Should -Invoke 'Write-Verbose' -ModuleName 'ADOPS' -Exactly -Times 1
        }
    }

}
