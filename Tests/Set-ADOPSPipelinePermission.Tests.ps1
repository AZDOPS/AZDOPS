param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe "Set-ADOPSPipelinePermission" {
    Context "Parameters" {
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
                Name = 'PipelineId'
                Mandatory = $true
                Type = 'int'
            },
            @{
                Name = 'ResourceType'
                Mandatory = $true
            },
            @{
                Name = 'ResourceId'
                Mandatory = $true
                Type = 'string'
            },
            @{
                Name = 'Authorized'
                Mandatory = $false
                Type = 'bool'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command Set-ADOPSPipelinePermission | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }

        It 'Should throw if ResourceType is not correct' {
            {Set-ADOPSPipelinePermission -Project "myproject" -PipelineId 1 -ResourceType "WrongType" -ResourceId 1} | Should -Throw
        }

    }
}
