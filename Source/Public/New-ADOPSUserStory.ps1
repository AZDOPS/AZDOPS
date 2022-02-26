function New-ADOPSUserStory {
  [CmdletBinding()]
  param (

    [Parameter(Mandatory,
      ParameterSetName = "Default")]
    [string]$Organization,

    [Parameter(Mandatory,
      ParameterSetName = "Default")]
    [string]$ProjectName,

    [Parameter(Mandatory,
      ParameterSetName = "Default")]
    [string]$Title,

    [Parameter(ParameterSetName = "Default")]
    [string]$Description,

    [Parameter(ParameterSetName = "Default")]
    [string]$Tags,        

    [Parameter(ParameterSetName = "Default")]
    [string]$Priority

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
    
  $InvokeSplat = @{
    Uri           = $URI
    ContentType   = "application/json-patch+json"
    Method        = $Method
    Body          = $Body
    Organization  = $Organization
  }

  InvokeADOPSRestMethod @InvokeSplat
}