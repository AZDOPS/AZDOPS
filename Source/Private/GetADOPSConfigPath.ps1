function GetADOPSConfigPath {
    Param()

    Join-Path -Path $env:TEMP -ChildPath 'ADOPS.config'
}