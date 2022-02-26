function New-ADOPSProject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Description,
        
        [Parameter(Mandatory)]
        [ValidateSet('Private', 'Public')]
        [string]$Visibility,
        
        [Parameter()]
        [ValidateSet('Git', 'Tfvc')]
        [string]$SourceControlType = 'Git',
        
        # The process type for the project, such as Basic, Agile, Scrum or CMMI
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$ProcessTypeName,
        
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Organization
    )

    if (-not [string]::IsNullOrEmpty($Organization)) {
        $OrgInfo = GetADOPSHeader -Organization $Organization
    }
    else {
        $OrgInfo = GetADOPSHeader
        $Organization = $OrgInfo['Organization']
    }

    # Get organization process templates
    $URI = "https://dev.azure.com/$Organization/_apis/process/processes?api-version=7.1-preview.1"

    $InvokeSplat = @{
        Method       = 'Get'
        Uri          = $URI
        Organization = $Organization
    }

    $ProcessTemplates = (InvokeADOPSRestMethod @InvokeSplat).value

    if ([string]::IsNullOrWhiteSpace($ProcessTypeName)) {
        $ProcessTemplateTypeId = $ProcessTemplates | Where-Object isDefault -eq $true | Select-Object -ExpandProperty id
    }
    else {
        $ProcessTemplateTypeId = $ProcessTemplates | Where-Object name -eq $ProcessTypeName | Select-Object -ExpandProperty id
        if ([string]::IsNullOrWhiteSpace($ProcessTemplateTypeId)) {
            throw "The specified ProcessTypeName was not found amongst options: $($ProcessTemplates.name -join ', ')!"
        }
    }

    # Create project endpoint
    $URI = "https://dev.azure.com/$Organization/_apis/projects?api-version=7.1-preview.4"

    $Body = @{
        'name'         = $Name
        'visibility'   = $Visibility
        'capabilities' = @{
            'versioncontrol'  = @{
                'sourceControlType' = $SourceControlType
            }
            'processTemplate' = @{
                'templateTypeId' = $ProcessTemplateTypeId
            }
        }
    }
    if (-not [string]::IsNullOrEmpty($Description)) {
        $Body.Add('description', $Description)
    }
    $Body = $Body | ConvertTo-Json -Compress
    
    $InvokeSplat = @{
        Method       = 'Post'
        Uri          = $URI
        Body         = $Body
        Organization = $Organization
    }

    InvokeADOPSRestMethod @InvokeSplat
}