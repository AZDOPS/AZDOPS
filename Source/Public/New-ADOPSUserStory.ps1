function New-ADOPSUserStory {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Title,

    [Parameter(Mandatory)]
    [string]$ProjectName,

    [Parameter()]
    [string]$Description,

    [Parameter()]
    [string]$Tags,

    [Parameter()]
    [string]$Priority,

    [Parameter()]
    [string]$Organization
  )

  if (-not [string]::IsNullOrEmpty($Organization)) {
    $Org = GetADOPSHeader -Organization $Organization
  }
  else {
    $Org = GetADOPSHeader
    $Organization = $Org['Organization']
  }


  $URI = "https://dev.azure.com/$Organization/$ProjectName/_apis/wit/workitems/`$User Story?api-version=5.1"
  $Method = 'POST'

  $desc = $Description.Replace('"', "'")
  $Body = "[
      {
        `"op`": `"add`",
        `"path`": `"/fields/System.Title`",
        `"value`": `"$($Title)`"
      },
      {
        `"op`": `"add`",
        `"path`": `"/fields/System.Description`",
        `"value`": `"$($desc)`"
      },
      {
        `"op`": `"add`",
        `"path`": `"/fields/System.Tags`",
        `"value`": `"$($Tags)`"
      },
      {
        `"op`": `"add`",
        `"path`": `"/fields/Microsoft.VSTS.Common.Priority`",
        `"value`": `"$($Priority)`"
      },	 
    ]"
    
  $ContentType= "application/json-patch+json"  
  
  $InvokeSplat = @{
    Uri           = $URI
    ContentType   = $ContentType
    Method        = $Method
    Body          = $Body
    Organization  = $Organization
  }

  InvokeADOPSRestMethod @InvokeSplat
}