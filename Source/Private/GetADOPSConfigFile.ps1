function GetADOPSConfigFile {
    param (
        [Parameter()]
        [string]$ConfigPath = (Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath 'adops.config.json')
    )
    
    # Create config if not exists
    if (-not (Test-Path $ConfigPath)) {
        NewADOPSConfigFile
    }
    
    Get-Content $ConfigPath | ConvertFrom-Json -AsHashtable
}