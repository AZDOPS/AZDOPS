function Get-ADOPSRepository {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Project,

        [Parameter()]
        [string]$Repository,

        [Parameter()]
        [string]$Organization
    )

    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }

    if ($PSBoundParameters.ContainsKey('Repository')) {
        $Uri = "https://dev.azure.com/$Organization/$Project/_apis/git/repositories/$Repository`?api-version=7.1-preview.1"
    }
    else {
        $Uri = "https://dev.azure.com/$Organization/$Project/_apis/git/repositories?api-version=7.1-preview.1"
    }
    
    try {
        $result = InvokeADOPSRestMethod -Uri $Uri -Method Get
    }
    catch [Microsoft.PowerShell.Commands.HttpResponseException] {
        $ErrorMessage = $_.ErrorDetails.Message | ConvertFrom-Json
        if ($ErrorMessage.message -like "TF401019:*") {
            Write-Verbose "The Git repository with name or identifier $Repository does not exist or you do not have permissions for the operation you are attempting."
            $result = $null
        }
        elseif ($ErrorMessage.message -like "TF200016:*") {
            Write-Verbose "The following project does not exist: $Project. Verify that the name of the project is correct and that the project exists on the specified Azure DevOps Server."
            $result = $null
        }
        else {
            Throw $_
        }
    }

    if ($result.psobject.properties.name -contains 'value') {
        Write-Output -InputObject $result.value
    }
    else {
        Write-Output -InputObject $result
    }
}