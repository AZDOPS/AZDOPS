function Set-ADOPSGitPermission {
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Organization,
        
        [Parameter(Mandatory)]
        [Alias('ProjectId')]
        [string]$Project,
        
        [Parameter(Mandatory)]
        [Alias('RepositoryId')]
        [string]$Repository,
        
        [Parameter(Mandatory)]
        [ValidatePattern('^[a-z]{3,5}\.[a-zA-Z0-9]{40,}$', ErrorMessage = 'Descriptor must be in the descriptor format')]
        [string]$Descriptor,
        
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [AccessLevels[]]$Allow,
        
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [AccessLevels[]]$Deny
    )
    
    # Allow input of names instead of IDs
    if ($Project -notmatch '^[a-z0-9]{8}\-[a-z0-9]{4}\-[a-z0-9]{4}\-[a-z0-9]{4}\-[a-z0-9]{12}$') {
        $Project = Get-ADOPSProject -Name $Project | Select-Object -ExpandProperty id
        if ($null -eq $Project) {
            throw "No project named $Project found."
        }
    }
    if ($Repository -notmatch '^[a-z0-9]{8}\-[a-z0-9]{4}\-[a-z0-9]{4}\-[a-z0-9]{4}\-[a-z0-9]{12}$') {
        $Repository = Get-ADOPSRepository -Repository $Repository -Project $Project
        if ($null -eq $Repository) {
            throw "No repository named $Repository in project $Project found."
        }
    }


    if (-not $Allow -and -not $Deny) {
        Write-Verbose 'No allow or deny rules set'
    }
    else {
        if ($null -eq $Allow) {
            $allowRules = 0
        }
        else {
            $allowRules = ([accesslevels]$Allow).value__
        }
        if ($null -eq $Deny) {
            $denyRules = 0
        }
        else {
            $denyRules = ([accesslevels]$Deny).value__
        }
    
        # If user didn't specify org, get it from saved context
        if ([string]::IsNullOrEmpty($Organization)) {
            $Organization = GetADOPSDefaultOrganization
        }
        
        $SubjectDescriptor = (InvokeADOPSRestMethod -Uri "https://vssps.dev.azure.com/$Organization/_apis/identities?subjectDescriptors=$Descriptor&queryMembership=None&api-version=7.1-preview.1" -Method Get).value.descriptor

        $Body = [ordered]@{
            token                = "repov2/$Projectid/$RepositoryId"
            merge                = $true
            accessControlEntries = @(
                [ordered]@{
                    allow      = $allowRules
                    deny       = $denyRules
                    descriptor = $SubjectDescriptor
                }
            )
        } | ConvertTo-Json -Compress -Depth 10
        
        $Uri = "https://dev.azure.com/$Organization/_apis/accesscontrolentries/2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87?api-version=7.1-preview.1"
        
        $InvokeSplat = @{
            Uri    = $Uri 
            Method = 'Post' 
            Body   = $Body
        }
        
        InvokeADOPSRestMethod @InvokeSplat
    }
}