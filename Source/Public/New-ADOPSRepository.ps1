function New-ADOPSRepository {
    param (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Organization,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Project,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Name
    )

    if (-not [string]::IsNullOrEmpty($Organization)) {
        $Org = GetADOPSHeader -Organization $Organization
    }
    else {
        $Org = GetADOPSHeader
        $Organization = $Org['Organization']
    }

    $ProjectID = (Get-ADOPSProject -Project $Project).id

    $URI = "https://dev.azure.com/$Organization/_apis/git/repositories?api-version=7.1-preview.1"
    $Body = "{""name"":""$Name"",""project"":{""id"":""$ProjectID""}}"

    $InvokeSplat = @{
        Uri           = $URI
        Method        = 'Post'
        Body          = $Body
        Organization  = $Organization
      }
    
      InvokeADOPSRestMethod @InvokeSplat
}