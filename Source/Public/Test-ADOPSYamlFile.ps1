function Test-ADOPSYamlFile {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Organization,

        [Parameter(Mandatory)]
        [string]$Project,

        [Parameter(Mandatory)]
        [ValidateScript({
            $_ -match '.*\.y[aA]{0,1}ml$'
        }, ErrorMessage = 'Fileextension must be ".yaml" or ".yml"')]
        [string]$File,

        [Parameter(Mandatory)]
        [int]$PipelineId
    )

    if (-not [string]::IsNullOrEmpty($Organization)) {
        $Org = GetADOPSHeader -Organization $Organization
    }
    else {
        $Org = GetADOPSHeader
        $Organization = $Org['Organization']
    }

    $Uri = "https://dev.azure.com/$Organization/$Project/_apis/pipelines/$PipelineId/runs?api-version=7.1-preview.1"

    $FileData = Get-Content $File -Raw

    $Body = @{
        previewRun = $true
        templateParameters = @{}
        resources = @{}
        yamlOverride = $FileData
    } | ConvertTo-Json -Depth 10 -Compress
    
    $InvokeSplat = @{
        Uri           = $URI
        Method        = 'Post'
        Body          = $Body
        Organization  = $Organization
      }
    
    try {
        $Result = InvokeADOPSRestMethod @InvokeSplat
        Write-Output "$file validation success."
    } 
    catch [Microsoft.PowerShell.Commands.HttpResponseException] {
        if ($_.ErrorDetails.Message) {
            $r = $_.ErrorDetails.Message | ConvertFrom-Json
            if ($r.typeName -like '*PipelineValidationException*') {
                Write-Warning "Validation failed:`n$($r.message)"
            }
            else {
                throw $_
            }
        }
    }
}
