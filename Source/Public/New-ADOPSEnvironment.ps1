function New-ADOPSEnvironment {
    param (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Organization,
        
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Project,
        
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,
        
        [Parameter()]
        [string]$Description,
        
        [Parameter()]
        [string]$AdminGroup,
        
        [Parameter()]
        [switch]$SkipAdmin
    )
     
    if (-not [string]::IsNullOrEmpty($Organization)) {
        $OrgInfo = GetADOPSHeader -Organization $Organization
    }
    else {
        $OrgInfo = GetADOPSHeader
        $Organization = $OrgInfo['Organization']
    }


    $Uri = "https://dev.azure.com/$organization/$project/_apis/distributedtask/environments?api-version=7.1-preview.1"

    $Body = [Ordered]@{
        name = $Name
        description = $Description
    } | ConvertTo-Json -Compress

    $InvokeSplat = @{
        Uri = $Uri
        Method = 'Post'
        Body = $Body
    }

    Write-Verbose "Setting up environment"
    $Environment = InvokeADOPSRestMethod @InvokeSplat

    if ($PSBoundParameters.ContainsKey('SkipAdmin')) {
        Write-Verbose 'Skipped admin group'
    }
    else {
        $secUri = "https://dev.azure.com/$organization/_apis/securityroles/scopes/distributedtask.environmentreferencerole/roleassignments/resources/$($Environment.project.id)_$($Environment.id)?api-version=7.1-preview.1"

        if ([string]::IsNullOrEmpty($AdminGroup)) {
            $AdmGroupPN = "[$project]\Project Administrators"
        } 
        else {
            $AdmGroupPN = $AdminGroup
        }
        $ProjAdm = (Get-ADOPSGroup | Where-Object {$_.principalName -eq $AdmGroupPN}).originId

        $SecInvokeSplat = @{
            Uri = $secUri
            Method = 'Put'
            Body = "[{`"userId`":`"$ProjAdm`",`"roleName`":`"Administrator`"}]"
        }

        try {
            $SecResult = InvokeADOPSRestMethod @SecInvokeSplat
        }
        catch {
            Write-Error 'Failed to update environment security. The environment may still have been created.'
        }
    }

    Write-Output $Environment
}