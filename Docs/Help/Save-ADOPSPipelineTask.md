---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Save-ADOPSPipelineTask

## SYNOPSIS
Saves the zip file of any task installed in an Azure DevOps organization.

## SYNTAX

### InputData (Default)
```
Save-ADOPSPipelineTask [-Organization <String>] [-Path <String>] -TaskId <String> -TaskVersion <Version>
 [-FileName <String>] [<CommonParameters>]
```

### InputObject
```
Save-ADOPSPipelineTask [-Organization <String>] [-Path <String>] [-InputObject] <PSObject[]>
 [<CommonParameters>]
```

## DESCRIPTION
This command  will download a zip file containing any task from yourAzure DevOps organization for you to explore or security review.

## EXAMPLES

### Example 1
```powershell
PS C:\> Save-ADOPSPipelineTask -TaskId 6c731c3c-3c68-459a-a5c9-bde6e6595b5b -TaskVersion 2.206.1
```

This command will download a zip file to the current folder.
The zip file will contain the task with task id "6c731c3c-3c68-459a-a5c9-bde6e6595b5b" (bash)
The zip file will be named "6c731c3c-3c68-459a-a5c9-bde6e6595b5b.2.206.1.zip" (taskid.version.zip)

### Example 2
```powershell
PS C:\> Save-ADOPSPipelineTask -Path C:\temp\tasks\ -TaskId 6c731c3c-3c68-459a-a5c9-bde6e6595b5b -TaskVersion 2.206.1 -FileName MyBashTask.zip
```

This command will download a zip file named "MyBashTask.zip" to the "C:\temp\tasks\" folder.
The zip file will contain the task with task id "6c731c3c-3c68-459a-a5c9-bde6e6595b5b" (bash)

### Example 3
```powershell
PS C:\> $r = Get-ADOPSPipelineTask
PS C:\> $r.Where({$_.name -eq 'PowerShell'})  | Save-ADOPSPipelineTask -Path c:\temp\tasks\
```

This command uses the Get-ADOPSPipelineTask to get all installed pipeline tasks.
It filters the tasks on the name "PowerShell" and downloads all matching tasks to the "c:\temp\tasks\" folder.
The zip files will be named "TaskName-TaskId-version.zip" (for example: "PowerShell-e213ff0f-5d5c-4791-802d-52ea3e7be1f1-1.2.3.zip")

### Example 4
```powershell
PS C:\> Save-ADOPSPipelineTask -Path c:\temp\tasks\ -InputObject @(
    @{
        id = "e213ff0f-5d5c-4791-802d-52ea3e7be1f1"
        name = "PowerShell"
        version = @{
            major = 1
            minor = 2
            patch = 3
        }
    },
    @{
        id = "e213ff0f-5d5c-4791-802d-52ea3e7be1f1"
        name = "PowerShell"
        version = @{
            major = 2
            minor = 212
            patch = 0
        }
    }
)
```

This command uses a list of hashtables to download two different tasks. The properties listed in the example _must_ be included in the objects to process.

## PARAMETERS

### -FileName
Filename to output the zipfile as.

```yaml
Type: String
Parameter Sets: InputData
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputObject
A list of tasks to download. This list _must_ contain the following properties:
id = guid of task
name = task name for file output
version = @{
    major = 1
    minor = 2
    patch = 3
}

You may use the command `Get-ADOPSPipelineTask` to get a properly created object.

```yaml
Type: PSObject[]
Parameter Sets: InputObject
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Organization
The organization where your tasks are installed.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
Path where zip files will be output.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TaskId
Id of the task to download. Can be found using the command `Get-ADOPSPipelineTask`.

```yaml
Type: String
Parameter Sets: InputData
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TaskVersion
Version in the format 'major.minor.build' of the task to download. Can be found using the command `Get-ADOPSPipelineTask`.

```yaml
Type: Version
Parameter Sets: InputData
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Management.Automation.PSObject[]

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
