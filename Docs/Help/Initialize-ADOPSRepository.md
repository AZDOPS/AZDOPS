---
external help file: ADOPS-help.xml
Module Name: ADOPS
online version:
schema: 2.0.0
---

# Initialize-ADOPSRepository

## SYNOPSIS
This command will initialize a newly created Azure DevOps repository. 

## SYNTAX

```
Initialize-ADOPSRepository [[-Message] <String>] [[-Branch] <String>] [-RepositoryId] <String>
 [[-newContentTemplate] <String[]>] [-Readme] [[-Path] <String>] [[-Content] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
This command will initialize a newly created Azure DevOps repository.
It can do so by adding a default README.md template, Any of the existing .gitignore templates, or a custom file.

If only one .gitignore template is selected it will be named ".gitignore". If more than one is selected they will be named as the templates, and they will not work right away. Combine your chosen templates in to one and update it manually.

If a repository is already initiated this command will fail with any of a number of different messages depending on what files or templates are selected.

## EXAMPLES

### Example 1
```PowerShell
PS C:\> $r = New-ADOPSRepository -Name "myNewRepo" -Project 'myProject' -Organization 'myOrg'
PS C:\> Initialize-ADOPSRepository
```

This command will initialize the repo with only the default "README.md" template. 

### Example 2
```powershell
PS C:\> $r = New-ADOPSRepository -Name "myNewRepo" -Project 'myProject' -Organization 'myOrg'
PS C:\> Initialize-ADOPSRepository -RepositoryId $r.id -Message 'my initial commit message' -newContentTemplate Actionscript.gitignore, Ada.gitignore, Android.gitignore -Path '/newCustomFile.txt' -Readme
```

This command will initialize a repository containing the files
- Actionscript.gitignore
- Ada.gitignore
- Android.gitignore
- newCustomFile.txt
- README.md

newCustomFile.txt will contain the default message 'Repo initialized using ADOPS module.'

README.md is the default readme template from Azure DevOps

### Example 3
```powershell
PS C:\> $r = New-ADOPSRepository -Name "myNewRepo" -Project 'myProject' -Organization 'myOrg'
PS C:\> $content = @'
This is a multiline file.
It contains multiple lines,
Since, by definition, if it didn't it wouldn't be a multiline file
'@
PS C:\> Initialize-ADOPSRepository -RepositoryId $r.id -Path '/newCustomFile.txt' -Content $content
```

This command will initialize the repo by creating the file 'newCustomFile.txt' in the root folder, and setting contents of the file.

## PARAMETERS

### -Branch
Which branch to initialize. Defaults to 'refs/heads/main'

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Content
If combined with the `-Path` parameter this will create a custom file with this content.

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

### -Message
Commit message to use when initializing repository

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
If combined with the `-Content` parameter this will create a custom file with this content.
If a path is given without `-Content` the default message 'Repo initialized using ADOPS module.' will be set in this file.

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

### -Readme
Initialize the repo with the default Azure DevOps README template

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RepositoryId
Id (GUID) of the repository to initialize.

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

### -newContentTemplate
Initialize the repo with one or more of the existing .gitignore templates.
If one template is selected it will be given the name '.gitignore'
If 2 or more templates are given they will be named as the template name.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:
Accepted values: Actionscript.gitignore, Ada.gitignore, Agda.gitignore, Android.gitignore, AppceleratorTitanium.gitignore, AppEngine.gitignore, ArchLinuxPackages.gitignore, Autotools.gitignore, C++.gitignore, C.gitignore, CakePHP.gitignore, CFWheels.gitignore, ChefCookbook.gitignore, Clojure.gitignore, CMake.gitignore, CodeIgniter.gitignore, CommonLisp.gitignore, Composer.gitignore, Concrete5.gitignore, Coq.gitignore, CraftCMS.gitignore, CUDA.gitignore, D.gitignore, Dart.gitignore, Delphi.gitignore, DM.gitignore, Drupal.gitignore, Eagle.gitignore, Elisp.gitignore, Elixir.gitignore, Elm.gitignore, EPiServer.gitignore, Erlang.gitignore, ExpressionEngine.gitignore, ExtJs.gitignore, Fancy.gitignore, Finale.gitignore, ForceDotCom.gitignore, Fortran.gitignore, FuelPHP.gitignore, gcov.gitignore, GitBook.gitignore, Go.gitignore, Godot.gitignore, Gradle.gitignore, Grails.gitignore, GWT.gitignore, Haskell.gitignore, Idris.gitignore, IGORPro.gitignore, Java.gitignore, Jboss.gitignore, Jekyll.gitignore, JENKINS_HOME.gitignore, Joomla.gitignore, Julia.gitignore, KiCAD.gitignore, Kohana.gitignore, Kotlin.gitignore, LabVIEW.gitignore, Laravel.gitignore, Leiningen.gitignore, LemonStand.gitignore, Lilypond.gitignore, Lithium.gitignore, Lua.gitignore, Magento.gitignore, Maven.gitignore, Mercury.gitignore, MetaProgrammingSystem.gitignore, nanoc.gitignore, Nim.gitignore, Node.gitignore, Objective-C.gitignore, OCaml.gitignore, Opa.gitignore, opencart.gitignore, OracleForms.gitignore, Packer.gitignore, Perl.gitignore, Phalcon.gitignore, PlayFramework.gitignore, Plone.gitignore, Prestashop.gitignore, Processing.gitignore, PureScript.gitignore, Python.gitignore, Qooxdoo.gitignore, Qt.gitignore, R.gitignore, Rails.gitignore, Raku.gitignore, RhodesRhomobile.gitignore, ROS.gitignore, Ruby.gitignore, Rust.gitignore, Sass.gitignore, Scala.gitignore, Scheme.gitignore, SCons.gitignore, Scrivener.gitignore, Sdcc.gitignore, SeamGen.gitignore, SketchUp.gitignore, Smalltalk.gitignore, stella.gitignore, SugarCRM.gitignore, Swift.gitignore, Symfony.gitignore, SymphonyCMS.gitignore, Terraform.gitignore, TeX.gitignore, Textpattern.gitignore, TurboGears2.gitignore, Typo3.gitignore, Umbraco.gitignore, Unity.gitignore, UnrealEngine.gitignore, VisualStudio.gitignore, VVVV.gitignore, Waf.gitignore, WordPress.gitignore, Xojo.gitignore, Yeoman.gitignore, Yii.gitignore, ZendFramework.gitignore, Zephir.gitignore

Required: False
Position: 3
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
