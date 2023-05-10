function GetADOPSConfigFile {
    param (
        [Parameter()]
        [string]$ConfigPath = '~/.ADOPS/Config.json'
    )
    
    # Create config if not exists
    if (-not (Test-Path $ConfigPath)) {
        NewADOPSConfigFile
    }
    
    Get-Content $ConfigPath | ConvertFrom-Json -AsHashtable
}