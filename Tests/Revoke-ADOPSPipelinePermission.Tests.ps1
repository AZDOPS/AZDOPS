param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe "Revoke-ADOPSPipelinePermission" {
    Context "Parameters" {
        $TestCases = @(
            @{
                Name = 'Organization'
                Mandatory = $false
                Type = 'String'
            },
            @{
                Name = 'Project'
                Mandatory = $true
                Type = 'String'
            },
            @{
                Name = 'PipelineId'
                Mandatory = $true
                Type = 'Int32'
            },
            @{
                Name = 'ResourceType'
                Mandatory = $true
                Type = 'ResourceType'
            },
            @{
                Name = 'ResourceId'
                Mandatory = $true
                Type = 'String'
            },
            @{
                Name = 'AllPipelines'
                Mandatory = $true
                Type = 'SwitchParameter'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command Revoke-ADOPSPipelinePermission | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory
            (Get-Command Grant-ADOPSPipelinePermission | Select-Object -ExpandProperty parameters)."$($_.Name)".ParameterType.Name | Should -Be $_.Type
        }

        It 'Should throw if ResourceType is not correct' {
            {Revoke-ADOPSPipelinePermission -Project "myproject" -PipelineId 1 -ResourceType "WrongType" -ResourceId 1} | Should -Throw
        }

    }

    Context "Revoking access to a pipeline" {
        BeforeAll {
            Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'myorg' }
            
            Mock Get-ADOPSProject -ModuleName ADOPS {
                @{
                    id = "de6a3035-0146-4ae2-81c1-68596d187cf4"
                }
            }

            Mock InvokeADOPSRestMethod -ModuleName ADOPS {
                @{
                    Uri = $Uri
                    Body = $Body
                    Method = $Method
                    Organization = $Organization
                }
            }
        }

        It 'If organization is given, it should not call GetADOPSDefaultOrganization' {
            $s =@{
                Project = 'MyProj'
                PipelineId = 1
                ResourceType ='VariableGroup'
                ResourceId ='ResId'
                Organization = 'MyOrg'
            }
            $r = Revoke-ADOPSPipelinePermission @s
            Should -Invoke -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -Times 0
        }

        It 'If organization is not given, it should call GetADOPSDefaultOrganization' {
            $s =@{
                Project = 'MyProj'
                PipelineId = 1
                ResourceType ='VariableGroup'
                ResourceId ='ResId'
            }
            $r = Revoke-ADOPSPipelinePermission @s
            Should -Invoke -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -Times 1
        }

        It "Should not get organization from GetADOPSDefaultOrganization when organization parameter is used" {
            Revoke-ADOPSPipelinePermission -Organization 'anotherorg' -Project "myproject" -PipelineId 42 -ResourceType "variablegroup" -ResourceId 1
            Should -Invoke GetADOPSDefaultOrganization -ModuleName ADOPS -Times 0 -Exactly
        }

        It "Should get organization using GetADOPSDefaultOrganization when organization parameter is not used" {
            Revoke-ADOPSPipelinePermission -Project "myproject" -PipelineId 42 -ResourceType "variablegroup" -ResourceId 1
            Should -Invoke GetADOPSDefaultOrganization -ModuleName ADOPS -Times 1 -Exactly
        }

        It "Should invoke with PATCH" {
            (Revoke-ADOPSPipelinePermission -Project "myproject" -PipelineId 42 -ResourceType "variablegroup" -ResourceId 1).Method | Should -Be "Patch"
        }

        It "Should invoke corret Uri when organization is not used" {
            (Revoke-ADOPSPipelinePermission -Project "myproject" -PipelineId 42 -ResourceType "variablegroup" -ResourceId 1).Uri | Should -Be "https://dev.azure.com/myorg/myproject/_apis/pipelines/pipelinepermissions/variablegroup/1?api-version=7.1-preview.1"
        }

        It "Should invoke corret Uri when organization is used" {
            (Revoke-ADOPSPipelinePermission -Organization "someorg" -Project "myproject" -PipelineId 42 -ResourceType "variablegroup" -ResourceId 1).Uri | Should -Be "https://dev.azure.com/someorg/myproject/_apis/pipelines/pipelinepermissions/variablegroup/1?api-version=7.1-preview.1"
        }     

        It "Should invoke with correct body for single pipeline" {
            $Request = (Revoke-ADOPSPipelinePermission -Project "myproject" -PipelineId 42 -ResourceType "variablegroup" -ResourceId 1)
            $Request.Body | Should -Be '{"pipelines":[{"id":42,"authorized":false}]}'
            $Request.Uri | Should -Be "https://dev.azure.com/myorg/myproject/_apis/pipelines/pipelinepermissions/variablegroup/1?api-version=7.1-preview.1"
        }

        It "Should invoke with correct body for all pipelines" {
            $Request = (Revoke-ADOPSPipelinePermission -Project "myproject" -AllPipelines -ResourceType "variablegroup" -ResourceId 1)
            $Request.Body | Should -Be '{"allpipelines":{"authorized":false}}'
            $Request.Uri | Should -Be "https://dev.azure.com/myorg/myproject/_apis/pipelines/pipelinepermissions/variablegroup/1?api-version=7.1-preview.1"
        }
    }
}
