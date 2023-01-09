param(
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeAll {
    Remove-Module ADOPS -Force -ErrorAction SilentlyContinue
    Import-Module $PSM1 -Force
}

Describe "Get-ADOPSPipelineTask" {
    BeforeAll {
        Mock GetADOPSHeader -ModuleName ADOPS -MockWith {
            @{
                Organization = "myorg"
            }
        }
        Mock GetADOPSHeader -ModuleName ADOPS -ParameterFilter { $Organization -eq 'anotherorg' } -MockWith {
            @{
                Organization = "anotherOrg"
            }
        }

        Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {}
    }

    Context "Parameters" {
        $TestCases = @(
            @{
                Name = 'Organization'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'Name'
                Mandatory = $false
                Type = 'string'
            },
            @{
                Name = 'Version'
                Mandatory = $false
                Type = 'int'
            }
        )

        It 'Should have parameter <_.Name>' -TestCases $TestCases  {
            Get-Command Get-ADOPSPipelineTask | Should -HaveParameter $_.Name -Mandatory:$_.Mandatory -Type $_.Type
        }
    }

    Context 'Functionality' {
        it 'Should get organization from GetADOPSHeader when organization parameter is used' {
            Get-ADOPSPipelineTask -Organization 'anotherorg'
            Should -Invoke GetADOPSHeader -ModuleName ADOPS -ParameterFilter { $Organization -eq 'anotherorg' } -Times 1 -Exactly
        }

        it 'Should validate organization using GetADOPSHeader when organization parameter is not used' {
            Get-ADOPSPipelineTask
            Should -Invoke GetADOPSHeader -ModuleName ADOPS -ParameterFilter { $Organization -eq 'anotherorg' } -Times 0 -Exactly
            Should -Invoke GetADOPSHeader -ModuleName ADOPS -Times 1 -Exactly
        }

        it 'It should call the API using no extra parameters' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
@"
{
    "count": 1,
    "value": "$Uri"
}
"@
            }

            Get-ADOPSPipelineTask | Should -Be 'https://dev.azure.com/myorg/_apis/distributedtask/tasks?api-version=7.1-preview.1'
        }

        it 'Because of how this endpoint behaves, output should be a hashtable' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
@'
{
"count": 231,
"value": [
    {
        "visibility": [
            "Build",
            "Release"
        ],
        "runsOn": [
            "Agent",
            "DeploymentGroup"
        ],
        "id": "e213ff0f-5d5c-4791-802d-52ea3e7be1f1",
        "name": "PowerShell",
        "version": {
            "major": 1,
            "minor": 2,
            "patch": 3,
            "isTest": false
        },
        "serverOwned": true,
        "contentsUploaded": true,
        "iconUrl": "https://dev.azure.com/bjornsundling/_apis/distributedtask/tasks/e213ff0f-5d5c-4791-802d-52ea3e7be1f1/1.2.3/icon",
        "minimumAgentVersion": "1.102",
        "friendlyName": "PowerShell",
        "description": "Run a PowerShell script",
        "category": "Utility",
        "helpMarkDown": "[More Information](https://go.microsoft.com/fwlink/?LinkID=613736)",
        "definitionType": "task",
        "author": "Microsoft Corporation",
        "demands": [
            "DotNetFramework"
        ],
        "groups": [
            {
                "name": "advanced",
                "displayName": "Advanced",
                "isExpanded": false
            }
        ],
        "inputs": [
            {
                "options": {
                    "inlineScript": "Inline Script",
                    "filePath": "File Path"
                },
                "name": "scriptType",
                "label": "Type",
                "defaultValue": "filePath",
                "required": true,
                "type": "pickList",
                "helpMarkDown": "Type of the script: File Path or Inline Script"
            },
            {
                "name": "scriptName",
                "label": "Script Path",
                "defaultValue": "",
                "required": true,
                "type": "filePath",
                "helpMarkDown": "Path of the script to execute. Should be fully qualified path or relative to the default working directory.",
                "visibleRule": "scriptType = filePath"
            },
            {
                "name": "arguments",
                "label": "Arguments",
                "defaultValue": "",
                "type": "string",
                "helpMarkDown": "Arguments passed to the PowerShell script.  Either ordinal parameters or named parameters"
            },
            {
                "name": "workingFolder",
                "label": "Working folder",
                "defaultValue": "",
                "type": "filePath",
                "helpMarkDown": "Current working directory when script is run.  Defaults to the folder where the script is located.",
                "groupName": "advanced"
            },
            {
                "properties": {
                    "resizable": "true",
                    "rows": "10",
                    "maxLength": "500"
                },
                "name": "inlineScript",
                "label": "Inline Script",
                "defaultValue": "# You can write your powershell scripts inline here. \n# You can also pass predefined and custom variables to this scripts using arguments\n\n Write-Host \"Hello World\"",
                "required": true,
                "type": "multiLine",
                "helpMarkDown": "",
                "visibleRule": "scriptType = inlineScript"
            },
            {
                "name": "failOnStandardError",
                "label": "Fail on Standard Error",
                "defaultValue": "true",
                "type": "boolean",
                "helpMarkDown": "If this is true, this task will fail if any errors are written to the error pipeline, or if any data is written to the Standard Error stream. Otherwise the task will rely solely on $LASTEXITCODE and the exit code to determine failure.",
                "groupName": "advanced"
            }
        ],
        "satisfies": [],
        "sourceDefinitions": [],
        "dataSourceBindings": [],
        "instanceNameFormat": "PowerShell Script",
        "preJobExecution": {},
        "execution": {
            "PowerShellExe": {
                "target": "$(scriptName)",
                "argumentFormat": "$(arguments)",
                "workingDirectory": "$(workingFolder)",
                "inlineScript": "$(inlineScript)",
                "scriptType": "$(scriptType)",
                "failOnStandardError": "$(failOnStandardError)"
            }
        },
        "postJobExecution": {}
    },
    {
        "visibility": [
            "Build",
            "Release"
        ],
        "runsOn": [
            "Agent",
            "DeploymentGroup"
        ],
        "id": "e213ff0f-5d5c-4791-802d-52ea3e7be1f1",
        "name": "PowerShell",
        "version": {
            "major": 2,
            "minor": 212,
            "patch": 0,
            "isTest": false
        },
        "serverOwned": true,
        "contentsUploaded": true,
        "iconUrl": "https://dev.azure.com/bjornsundling/_apis/distributedtask/tasks/e213ff0f-5d5c-4791-802d-52ea3e7be1f1/2.212.0/icon",
        "minimumAgentVersion": "2.115.0",
        "friendlyName": "PowerShell",
        "description": "Run a PowerShell script on Linux, macOS, or Windows",
        "category": "Utility",
        "helpMarkDown": "[Learn more about this task](https://go.microsoft.com/fwlink/?LinkID=613736)",
        "helpUrl": "https://docs.microsoft.com/azure/devops/pipelines/tasks/utility/powershell",
        "releaseNotes": "Script task consistency. Added support for macOS and Linux.",
        "definitionType": "task",
        "showEnvironmentVariables": true,
        "author": "Microsoft Corporation",
        "demands": [],
        "groups": [
            {
                "name": "preferenceVariables",
                "displayName": "Preference Variables",
                "isExpanded": false
            },
            {
                "name": "advanced",
                "displayName": "Advanced",
                "isExpanded": false
            }
        ],
        "inputs": [
            {
                "options": {
                    "filePath": "File Path",
                    "inline": "Inline"
                },
                "name": "targetType",
                "label": "Type",
                "defaultValue": "filePath",
                "type": "radio",
                "helpMarkDown": "Target script type: File Path or Inline"
            },
            {
                "name": "filePath",
                "label": "Script Path",
                "defaultValue": "",
                "required": true,
                "type": "filePath",
                "helpMarkDown": "Path of the script to execute. Must be a fully qualified path or relative to $(System.DefaultWorkingDirectory).",
                "visibleRule": "targetType = filePath"
            },
            {
                "name": "arguments",
                "label": "Arguments",
                "defaultValue": "",
                "type": "string",
                "helpMarkDown": "Arguments passed to the PowerShell script. Either ordinal parameters or named parameters.",
                "visibleRule": "targetType = filePath"
            },
            {
                "properties": {
                    "resizable": "true",
                    "rows": "10",
                    "maxLength": "20000"
                },
                "name": "script",
                "label": "Script",
                "defaultValue": "# Write your PowerShell commands here.\n\nWrite-Host \"Hello World\"\n",
                "required": true,
                "type": "multiLine",
                "helpMarkDown": "",
                "visibleRule": "targetType = inline"
            },
            {
                "options": {
                    "default": "Default",
                    "stop": "Stop",
                    "continue": "Continue",
                    "silentlyContinue": "SilentlyContinue"
                },
                "name": "errorActionPreference",
                "label": "ErrorActionPreference",
                "defaultValue": "stop",
                "type": "pickList",
                "helpMarkDown": "When not `Default`, prepends the line `$ErrorActionPreference = 'VALUE'` at the top of your script.",
                "groupName": "preferenceVariables"
            },
            {
                "options": {
                    "default": "Default",
                    "stop": "Stop",
                    "continue": "Continue",
                    "silentlyContinue": "SilentlyContinue"
                },
                "name": "warningPreference",
                "label": "WarningPreference",
                "defaultValue": "default",
                "type": "pickList",
                "helpMarkDown": "When not `Default`, prepends the line `$WarningPreference = 'VALUE'` at the top of your script.",
                "groupName": "preferenceVariables"
            },
            {
                "options": {
                    "default": "Default",
                    "stop": "Stop",
                    "continue": "Continue",
                    "silentlyContinue": "SilentlyContinue"
                },
                "name": "informationPreference",
                "label": "InformationPreference",
                "defaultValue": "default",
                "type": "pickList",
                "helpMarkDown": "When not `Default`, prepends the line `$InformationPreference = 'VALUE'` at the top of your script.",
                "groupName": "preferenceVariables"
            },
            {
                "options": {
                    "default": "Default",
                    "stop": "Stop",
                    "continue": "Continue",
                    "silentlyContinue": "SilentlyContinue"
                },
                "name": "verbosePreference",
                "label": "VerbosePreference",
                "defaultValue": "default",
                "type": "pickList",
                "helpMarkDown": "When not `Default`, prepends the line `$VerbosePreference = 'VALUE'` at the top of your script.",
                "groupName": "preferenceVariables"
            },
            {
                "options": {
                    "default": "Default",
                    "stop": "Stop",
                    "continue": "Continue",
                    "silentlyContinue": "SilentlyContinue"
                },
                "name": "debugPreference",
                "label": "DebugPreference",
                "defaultValue": "default",
                "type": "pickList",
                "helpMarkDown": "When not `Default`, prepends the line `$DebugPreference = 'VALUE'` at the top of your script.",
                "groupName": "preferenceVariables"
            },
            {
                "options": {
                    "default": "Default",
                    "stop": "Stop",
                    "continue": "Continue",
                    "silentlyContinue": "SilentlyContinue"
                },
                "name": "progressPreference",
                "label": "ProgressPreference",
                "defaultValue": "silentlyContinue",
                "type": "pickList",
                "helpMarkDown": "When not `Default`, prepends the line `$ProgressPreference = 'VALUE'` at the top of your script.",
                "groupName": "preferenceVariables"
            },
            {
                "name": "failOnStderr",
                "label": "Fail on Standard Error",
                "defaultValue": "false",
                "type": "boolean",
                "helpMarkDown": "If this is true, this task will fail if any errors are written to the error pipeline, or if any data is written to the Standard Error stream. Otherwise the task will rely on the exit code to determine failure.",
                "groupName": "advanced"
            },
            {
                "name": "showWarnings",
                "label": "Show warnings as Azure DevOps warnings",
                "defaultValue": "false",
                "type": "boolean",
                "helpMarkDown": "If this is true, and your script writes a warnings - they are shown as warnings also in pipeline logs",
                "groupName": "advanced"
            },
            {
                "name": "ignoreLASTEXITCODE",
                "label": "Ignore $LASTEXITCODE",
                "defaultValue": "false",
                "type": "boolean",
                "helpMarkDown": "If this is false, the line `if ((Test-Path -LiteralPath variable:\\LASTEXITCODE)) { exit $LASTEXITCODE }` is appended to the end of your script. This will cause the last exit code from an external command to be propagated as the exit code of powershell. Otherwise the line is not appended to the end of your script.",
                "groupName": "advanced"
            },
            {
                "name": "pwsh",
                "label": "Use PowerShell Core",
                "defaultValue": "false",
                "type": "boolean",
                "helpMarkDown": "If this is true, then on Windows the task will use pwsh.exe from your PATH instead of powershell.exe.",
                "groupName": "advanced"
            },
            {
                "name": "workingDirectory",
                "label": "Working Directory",
                "defaultValue": "",
                "type": "filePath",
                "helpMarkDown": "Working directory where the script is run.",
                "groupName": "advanced"
            },
            {
                "name": "runScriptInSeparateScope",
                "label": "Run script in the separate scope",
                "defaultValue": "false",
                "type": "boolean",
                "helpMarkDown": "This input allows executing PowerShell scripts using '&' operator instead of the default '.'. If this input set to the true script will be executed in separate scope and globally scoped PowerShell variables won't be updated",
                "groupName": "advanced"
            }
        ],
        "satisfies": [],
        "sourceDefinitions": [],
        "dataSourceBindings": [],
        "instanceNameFormat": "PowerShell Script",
        "preJobExecution": {},
        "execution": {
            "PowerShell3": {
                "target": "powershell.ps1",
                "platforms": [
                    "windows"
                ]
            },
            "Node10": {
                "target": "powershell.js",
                "argumentFormat": ""
            },
            "Node16": {
                "target": "powershell.js",
                "argumentFormat": ""
            }
        },
        "postJobExecution": {}
    }
]
}
'@
            }
            Get-ADOPSPipelineTask | Should -BeOfType 'hashtable'
        }

        it 'If a name is given it should return only that name, one version returned' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
@'
{
    "count": 231,
    "value": [
        {
            "name": "PowerShell",
            "version": {
                "major": 1,
                "minor": 102,
                "patch": 0,
                "isTest": false
            }
        },
        {
            "name": "AnotherPowerShellTask",
            "version": {
                "major": 3,
                "minor": 302,
                "patch": 0,
                "isTest": false
            }
        },
        {
            "name": "Bash",
            "version": {
                "major": 2,
                "minor": 212,
                "patch": 0,
                "isTest": false
            }
        }
    ]
}
'@
            }

            (Get-ADOPSPipelineTask -Name 'PowerShell' | Select-Object -ExpandProperty name).count | Should -Be 1
        }

        it 'If a name is given it should return only that name, two versions returned' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
@'
{
    "count": 231,
    "value": [
        {
            "name": "PowerShell",
            "version": {
                "major": 1,
                "minor": 102,
                "patch": 0,
                "isTest": false
            }
        },
        {
            "name": "PowerShell",
            "version": {
                "major": 3,
                "minor": 302,
                "patch": 0,
                "isTest": false
            }
        },
        {
            "name": "Bash",
            "version": {
                "major": 2,
                "minor": 212,
                "patch": 0,
                "isTest": false
            }
        }
    ]
}
'@
            }

            (Get-ADOPSPipelineTask -Name 'PowerShell' | Select-Object -ExpandProperty name).count | Should -Be 2
        }

        it 'If a version is given it should return only that version, one version returned' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
@'
{
    "count": 231,
    "value": [
        {
            "name": "PowerShell",
            "version": {
                "major": 1,
                "minor": 102,
                "patch": 0,
                "isTest": false
            }
        },
        {
            "name": "AnotherPowerShellTask",
            "version": {
                "major": 3,
                "minor": 302,
                "patch": 0,
                "isTest": false
            }
        },
        {
            "name": "Bash",
            "version": {
                "major": 2,
                "minor": 212,
                "patch": 0,
                "isTest": false
            }
        }
    ]
}
'@
            }

            (Get-ADOPSPipelineTask -Version 1 | Select-Object -ExpandProperty name).count | Should -Be 1
        }

        it 'If a version is given it should return only that version, two versions returned' {
            Mock -CommandName InvokeADOPSRestMethod -ModuleName ADOPS -MockWith {
@'
{
    "count": 231,
    "value": [
        {
            "name": "PowerShell",
            "version": {
                "major": 1,
                "minor": 102,
                "patch": 0,
                "isTest": false
            }
        },
        {
            "name": "PowerShell",
            "version": {
                "major": 3,
                "minor": 302,
                "patch": 0,
                "isTest": false
            }
        },
        {
            "name": "Bash",
            "version": {
                "major": 1,
                "minor": 212,
                "patch": 0,
                "isTest": false
            }
        }
    ]
}
'@
            }

            (Get-ADOPSPipelineTask  -Version 1  | Select-Object -ExpandProperty name).count | Should -Be 2
        }
    }
}