function Save-ADOPSPipelineTask {
    [CmdletBinding(DefaultParameterSetName = 'InputData')]
    param (
        [Parameter(ParameterSetName = 'InputData')]
        [Parameter(ParameterSetName = 'InputObject')]
        [string]$Organization,

        [Parameter(ParameterSetName = 'InputData')]
        [Parameter(ParameterSetName = 'InputObject')]
        [string]$Path = ".",

        [Parameter(Mandatory, ParameterSetName = 'InputData')]
        [string]$TaskId,

        [Parameter(Mandatory, ParameterSetName = 'InputData')]
        [version]$TaskVersion,

        [Parameter(ParameterSetName = 'InputData')]
        [string]$FileName,

        [Parameter(Mandatory, ParameterSetName = 'InputObject', ValueFromPipeline, Position = 0)]
        [psobject[]]$InputObject
    )
    begin {}
    process {
        if (-not [string]::IsNullOrEmpty($Organization)) {
            $Org = GetADOPSHeader -Organization $Organization
        }
        else {
            $Org = GetADOPSHeader
            $Organization = $Org['Organization']
        }

        switch ($PSCmdlet.ParameterSetName) {
            'InputData' {
                if ([string]::IsNullOrEmpty($FileName)) {
                    $FileName = "$TaskId.$($TaskVersion.ToString(3)).zip"
                }
                if (-Not $FileName -match '.zip$' ) {
                    $FileName = "$FileName.zip"
                }

                [array]$FilesToDownload = @{
                    TaskId = $TaskId
                    TaskVersionString = $TaskVersion.ToString(3)
                    OutputFile = Join-Path -Path $Path -ChildPath $FileName
                }
            }
            'InputObject' {
                [array]$FilesToDownload = foreach ($o in $InputObject) {
                    @{
                        TaskId = $o.id
                        TaskVersionString = "$($o.version.major).$($o.version.minor).$($o.version.patch)"
                        OutputFile = Join-Path -Path $Path -ChildPath "$($o.name)-$($o.id)-$($o.version.major).$($o.version.minor).$($o.version.patch).zip"
                    }
                }
            }
        }

        foreach ($File in $FilesToDownload) {
            $Url = "https://dev.azure.com/$Organization/_apis/distributedtask/tasks/$($File.TaskId)/$($File.TaskversionString)"
            InvokeADOPSRestMethod -Uri $Url -Method Get -OutFile $File.OutputFile -Organization $Organization 
        }
    }
    end {}
}