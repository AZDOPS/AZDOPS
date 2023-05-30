param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe 'New-ADOPSAuditStream' {
    Context 'Parameters' {
        $TestCases = @(
            @{
                Name      = 'Organization'
                Mandatory = $false
                Type      = 'string'
            },
            @{
                Name      = 'SplunkUrl'
                Mandatory = $true
                Type      = 'string'
            },
            @{
                Name      = 'SplunkEventCollectorToken'
                Mandatory = $true
                Type      = 'string'
            },
            @{
                Name      = 'WorkspaceId'
                Mandatory = $true
                Type      = 'string'
            },
            @{
                Name      = 'SharedKey'
                Mandatory = $true
                Type      = 'string'
            },
            @{
                Name      = 'EventGridTopicHostname'
                Mandatory = $true
                Type      = 'string'
            },
            @{
                Name      = 'EventGridTopicAccessKey'
                Mandatory = $true
                Type      = 'string'
            }
        )
    
        It 'Should have parameter <_.Name>' -TestCases $TestCases {
            Get-Command New-ADOPSAuditStream | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }
    
    Context 'functionality' {
        BeforeAll {
            InModuleScope -ModuleName ADOPS {
                Mock -CommandName GetADOPSDefaultOrganization -ModuleName ADOPS -MockWith { 'DummyOrg' }
    
                Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
                    return $InvokeSplat
                }
            }
        }
        
        It 'Should not get organization from GetADOPSDefaultOrganization when organization parameter is used' {
            New-ADOPSAuditStream -Organization 'anotherorg' -WorkspaceId '11111111-1111-1111-1111-111111111111' -SharedKey '123456'
            Should -Invoke GetADOPSDefaultOrganization -ModuleName ADOPS -Times 0 -Exactly
        }

        It 'Should get organization using GetADOPSDefaultOrganization when organization parameter is not used' {
            New-ADOPSAuditStream -WorkspaceId '11111111-1111-1111-1111-111111111111' -SharedKey '123456'
            Should -Invoke GetADOPSDefaultOrganization -ModuleName ADOPS -Times 1 -Exactly
        }

        It 'Should have three parameterSets' {
            $c = Get-Command New-ADOPSAuditStream
            $c.ParameterSets.Name.Count | Should -Be 3
        }

        It 'Default parameterSet should be AzureMonitorLogs' {
            $c = Get-Command New-ADOPSAuditStream
            $c.DefaultParameterSet | Should -Be 'AzureMonitorLogs'
        }

        It 'parameterSet names should be AzureMonitorLogs, Splunk, AzureEventGrid' {
            $c = Get-Command New-ADOPSAuditStream
            $c.ParameterSets.Name | Should -Contain 'AzureMonitorLogs'
            $c.ParameterSets.Name | Should -Contain 'Splunk'
            $c.ParameterSets.Name | Should -Contain 'AzureEventGrid'
        }

        It 'Verifying Uri' {
            $c = New-ADOPSAuditStream -WorkspaceId '11111111-1111-1111-1111-111111111111' -SharedKey '123456' -Organization 'Organization'
            $c.Uri | Should -Be 'https://auditservice.dev.azure.com/Organization/_apis/audit/streams?api-version=7.1-preview.1'
        }

        It 'Method should be Post' {
            $c = New-ADOPSAuditStream -WorkspaceId '11111111-1111-1111-1111-111111111111' -SharedKey '123456' -Organization 'Organization'
            $c.Method | Should -Be 'Post'
        }

        It 'Verify body, AzureMonitorLogs' {
            $c = New-ADOPSAuditStream -WorkspaceId '11111111-1111-1111-1111-111111111111' -SharedKey '123456' -Organization 'Organization'
            $c.Body | Should -Be '{"consumerType":"AzureMonitorLogs","consumerInputs":{"WorkspaceId":"11111111-1111-1111-1111-111111111111","SharedKey":"123456"}}'
        }

        It 'Verify body, Splunk' {
            $c = New-ADOPSAuditStream -SplunkUrl 'http://Splunkurl' -SplunkEventCollectorToken '11111111-1111-1111-1111-111111111111' -Organization 'Organization'
            $c.Body | Should -Be '{"consumerType":"Splunk","consumerInputs":{"SplunkUrl":"http://Splunkurl","SplunkEventCollectorToken":"11111111-1111-1111-1111-111111111111"}}'
        }

        It 'Verify body, AzureEventGrid' {
            $Bytes = [System.Text.Encoding]::Unicode.GetBytes('TopicAccessKey')
            $Base64 = [Convert]::ToBase64String($Bytes)
            $c = New-ADOPSAuditStream -EventGridTopicHostname 'http://eventgridUri' -EventGridTopicAccessKey $Base64 -Organization 'Organization'
            $c.Body | Should -Be ('{"consumerType":"AzureEventGrid","consumerInputs":{"EventGridTopicHostname":"http://eventgridUri","EventGridTopicAccessKey":"' + $Base64 + '"}}')
        }

        It 'Should throw if SplunkEventCollectorToken is not a GUID' {
            { New-ADOPSAuditStream -SplunkUrl 'http://Splunkurl' -SplunkEventCollectorToken 'NotAGuid' -Organization 'Organization' } | Should -Throw
        }

        It 'Should throw if WorkspaceId is not a GUID' {
            { New-ADOPSAuditStream -WorkspaceId 'NotAGuid' -SharedKey '123456' -Organization 'Organization' } | Should -Throw
        }

        It 'Should throw if SplunkUrl does not start with http(s)://' {
            { New-ADOPSAuditStream -SplunkUrl 'notcorrect.com' -SplunkEventCollectorToken '11111111-1111-1111-1111-111111111111' -Organization 'Organization' } | Should -Throw
        }

        It 'Should throw if EventGridTopicHostname does not start with http(s)://' {
            $Bytes = [System.Text.Encoding]::Unicode.GetBytes('TopicAccessKey')
            $Base64 = [Convert]::ToBase64String($Bytes)
            { New-ADOPSAuditStream -EventGridTopicHostname 'eventgridUri' -EventGridTopicAccessKey $Base64 -Organization 'Organization' } | Should -Throw
        }

        It 'Should throw if EventGridTopicAccessKey contains non base64 characters' {
            { New-ADOPSAuditStream -EventGridTopicHostname 'http://eventgridUri' -EventGridTopicAccessKey 'spaces notallowed' -Organization 'Organization' } | Should -Throw
        }
    }
}