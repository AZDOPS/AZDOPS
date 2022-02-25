#Requires -Module @{ ModuleName = 'Pester'; ModuleVersion = '5.3.1' }

Remove-Module AZDOPS -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot\..\Source\AZDOPS

InModuleScope -ModuleName AZDOPS {
    Describe 'New-AZDOPSUserStory tests' {

        Context 'Parameters' {
            It 'Should have parameter Organization' {
                (Get-Command New-AZDOPSUserStory).Parameters.Keys | Should -Contain 'Organization'
            }
            It 'Should have parameter ProjectName' {
                (Get-Command New-AZDOPSUserStory).Parameters.Keys | Should -Contain 'ProjectName'
            }
            It 'ProjectName should be required' {
                (Get-Command New-AZDOPSUserStory).Parameters['ProjectName'].Attributes.Mandatory | Should -Be $true
            }
            It 'Should have parameter Title' {
                (Get-Command New-AZDOPSUserStory).Parameters.Keys | Should -Contain 'Title'
            }
            It 'Title should be required' {
                (Get-Command New-AZDOPSUserStory).Parameters['Title'].Attributes.Mandatory | Should -Be $true
            }
            It 'Should have parameter Description' {
                (Get-Command New-AZDOPSUserStory).Parameters.Keys | Should -Contain 'Description'
            }
            It 'Description should not be required' {
                (Get-Command New-AZDOPSUserStory).Parameters['Description'].Attributes.Mandatory | Should -Be $false
            }
            It 'Should have parameter Tags' {
                (Get-Command New-AZDOPSUserStory).Parameters.Keys | Should -Contain 'Tags'
            }
            It 'Tags should not be required' {
                (Get-Command New-AZDOPSUserStory).Parameters['Tags'].Attributes.Mandatory | Should -Be $false
            }
            It 'Should have parameter Priority' {
                (Get-Command New-AZDOPSUserStory).Parameters.Keys | Should -Contain 'Priority'
            }
            It 'Priority should not be required' {
                (Get-Command New-AZDOPSUserStory).Parameters['Priority'].Attributes.Mandatory | Should -Be $false
            }
        }
    }
}