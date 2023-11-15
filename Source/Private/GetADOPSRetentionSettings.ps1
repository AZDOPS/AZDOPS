# @{
#     # UX Label: Days to keep artifacts, symbols and attachments
#     # UX Field: PurgeArtifacts
#     # Get Field: purgeArtifacts
#     # Patch Field: artifactsRetention 
#     purgeArtifacts               = @{
#         min   = 1
#         max   = 60
#         value = 51
#     }

#     # UX Label: Days to keep runs
#     # UX Field: PurgeRuns
#     # Get Field: purgeRuns
#     # Patch Field: runRetention
#     purgeRuns                    = @{
#         min   = 30
#         max   = 731
#         value = 37
#     }

#     # UX Label: Days to keep pull request runs
#     # UX Field: PurgePullRequestRuns
#     # Get Field: purgePullRequestRuns
#     # Patch Field: pullRequestRunRetention
#     purgePullRequestRuns         = @{
#         min   = 1
#         max   = 30
#         value = 4
#     }

#     # UX Label: Number of recent runs to retain per pipeline
#     # UX Help Label: This many runs will also be retained per protected branch and default pipeline branch. (Azure Repos only)
#     # UX Field: runsToRetainPerProtectedBranch
#     # Get Field: retainRunsPerProtectedBranch
#     # Patch Field: retainRunsPerProtectedBranch
#     # BUG: Always null on return
#     retainRunsPerProtectedBranch = @{
#         min   = 0
#         max   = 50
#         value = 0
#     }
# }

function GetADOPSRetentionSettings {
    [CmdletBinding()]
    [SkipTest('HasOrganizationParameter')]
    param (
        [Parameter(Mandatory)]
        $Response
    )

    $Settings = @{}

    $FieldMap = @{
        'purgeArtifacts'               = 'artifactsRetention'
        'purgeRuns'                    = 'runRetention'
        'purgePullRequestRuns'         = 'pullRequestRunRetention'

        # Note: This field is bugged, it's always NULL on GET/PATCH response, I think its meant to be runsToRetainPerProtectedBranch
        'retainRunsPerProtectedBranch' = 'retainRunsPerProtectedBranch' 
    }
    $Fields = $Response.psobject.Properties | Where-object Name -in $FieldMap.Keys 

    foreach ($Field in $Fields) {
        $Settings.$($FieldMap[$Field.Name]) = $Field.Value.value
    }

    [pscustomobject]$Settings
}


function PatchADOPSRetentionSettings {
    [CmdletBinding()]
    [SkipTest('HasOrganizationParameter')]
    param (
        [Parameter(Mandatory)]
        $Values
    )


    $Settings = @{}
    if ($Values -is [pscustomobject]) {
        foreach ($ValueProperty in $Values.psobject.Properties) {
            $Settings[$ValueProperty.Name] = @{
                value = $ValueProperty.Value
                min   = $null
                max   = $null
            }
        }
    }
    else {
        foreach ($Value in $Values.GetEnumerator()) {
            $Settings[$Value.key] = @{
                value = $Value.value
                min   = $null
                max   = $null
            }
        }
    }

    [pscustomobject]$Settings
}