---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# New-ADOPSGitFile

## SYNOPSIS
This command uploads a file to an Azure DevOps repository using the API.

## SYNTAX

```
New-ADOPSGitFile [[-Organization] <String>] [-Project] <String> [-Repository] <String> [-File] <String>
 [[-FileName] <String>] [[-Path] <String>] [[-CommitMessage] <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
This command uploads a file to an Azure DevOps repository using the API. If no other than required parameters are given it will be named as the source file and located in the root ("/") folder of the repository, with a default commit messadge of "File added using the ADOPS PowerShell module".
You may override target filename, path, and commit message.

## EXAMPLES

### Example 1
```powershell
PS C:\> New-ADOPSGitFile -Project 'myProject' -Repository 'myRepo' -File .\myFileToUplad.txt 
```

This will add the file 'myFileToUplad.txt' in the root ('/') folder of the 'myRepo'. It will contain the same data as the local file. It will be commited using the default commit message 'File added using the ADOPS PowerShell module'

### Example 2
```powershell
PS C:\> New-ADOPSGitFile -Project 'myProject' -Repository 'myRepo' -File .\myFileToUplad.txt -FileName 'newFileName.txt' -Path 'root/folder'
```

This will add the file 'newFileName.txt' in the relative folder '/root/folder' folder of the 'myRepo'. It will contain the same data as the loca file '.\myFileToUpload.txt'. It will be commited using the default commit message 'File added using the ADOPS PowerShell module'
Please note the path uses slash ('/') as path separator and is always relative to the root.

### Example 3
```powershell
PS C:\> New-ADOPSGitFile -Project 'myProject' -Repository 'myRepo' -File .\myFileToUplad.txt -CommitMessage 'Added this file'
```

This will add the file 'myFileToUplad.txt' in the root ('/') folder of the 'myRepo'. It will contain the same data as the local file. It will be commited using the commit message 'Added this file'


## PARAMETERS

### -CommitMessage
Override the default commit message

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -File
Path to the local file to upload to the Azure DevOps repository.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FileName
If set this will give the file a new filename in the Azure DevOps repository.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Organization
The organization to connect to

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
Sets the path to the file, relative to the root in Azure DevOps. Must use slash ('/') as path separator.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Project
The project where the repository is located

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Repository
Repository name where the file will be uploaded.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
