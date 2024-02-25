function Set-ADOPSBuildDefinition {
    [CmdletBinding()]
    Param(
        [Parameter()]
        [string]$Organization,
        
        [Parameter(Mandatory)]
        [Alias('Definition')]
        [Object]$DefinitionObject
    )

    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }

    $project = $DefinitionObject.project.id
    $id = $DefinitionObject.id

    $Uri = "https://dev.azure.com/${Organization}/${project}/_apis/build/definitions/${id}?api-version=7.2-preview.7"
    $Method = 'Put'

    if (-Not ($DefinitionObject -is [string])) {
        $DefinitionObject = $DefinitionObject | ConvertTo-Json -Compress -Depth 100
    }

    $InvokeSplat = @{
        Uri = $Uri
        Method = $Method
        Body = $DefinitionObject
    }

    InvokeADOPSRestMethod @InvokeSplat
}