function New-ADOPSRepository {
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Project,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Organization
    )

    # If user didn't specify org, get it from saved context
    if ([string]::IsNullOrEmpty($Organization)) {
        $Organization = GetADOPSDefaultOrganization
    }

    $ProjectID = (Get-ADOPSProject -Project $Project -Organization $Organization).id

    $URI = "https://dev.azure.com/$Organization/_apis/git/repositories?api-version=7.1-preview.1"
    $Body = "{""name"":""$Name"",""project"":{""id"":""$ProjectID""}}"

    $InvokeSplat = @{
        Uri          = $URI
        Method       = 'Post'
        Body         = $Body
        Organization = $Organization
    }
    
    InvokeADOPSRestMethod @InvokeSplat
}