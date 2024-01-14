function Initialize-ADOPSRepository {
    [CmdletBinding()]
    [SkipTest('HasOrganizationParameter')]
    param (
        [Parameter()]
        [string]$Message = 'Repo initialized using ADOPS module.',
        
        [Parameter()]
        [string]$Branch = 'Main',

        [Parameter(Mandatory)]
        [string]$RepositoryId,
        
        [Parameter()]
        [ValidateSet('Actionscript.gitignore', 'Ada.gitignore', 'Agda.gitignore', 'Android.gitignore', 'AppceleratorTitanium.gitignore', 'AppEngine.gitignore', 'ArchLinuxPackages.gitignore', 'Autotools.gitignore', 'C++.gitignore', 'C.gitignore', 'CakePHP.gitignore', 'CFWheels.gitignore', 'ChefCookbook.gitignore', 'Clojure.gitignore', 'CMake.gitignore', 'CodeIgniter.gitignore', 'CommonLisp.gitignore', 'Composer.gitignore', 'Concrete5.gitignore', 'Coq.gitignore', 'CraftCMS.gitignore', 'CUDA.gitignore', 'D.gitignore', 'Dart.gitignore', 'Delphi.gitignore', 'DM.gitignore', 'Drupal.gitignore', 'Eagle.gitignore', 'Elisp.gitignore', 'Elixir.gitignore', 'Elm.gitignore', 'EPiServer.gitignore', 'Erlang.gitignore', 'ExpressionEngine.gitignore', 'ExtJs.gitignore', 'Fancy.gitignore', 'Finale.gitignore', 'ForceDotCom.gitignore', 'Fortran.gitignore', 'FuelPHP.gitignore', 'gcov.gitignore', 'GitBook.gitignore', 'Go.gitignore', 'Godot.gitignore', 'Gradle.gitignore', 'Grails.gitignore', 'GWT.gitignore', 'Haskell.gitignore', 'Idris.gitignore', 'IGORPro.gitignore', 'Java.gitignore', 'Jboss.gitignore', 'Jekyll.gitignore', 'JENKINS_HOME.gitignore', 'Joomla.gitignore', 'Julia.gitignore', 'KiCAD.gitignore', 'Kohana.gitignore', 'Kotlin.gitignore', 'LabVIEW.gitignore', 'Laravel.gitignore', 'Leiningen.gitignore', 'LemonStand.gitignore', 'Lilypond.gitignore', 'Lithium.gitignore', 'Lua.gitignore', 'Magento.gitignore', 'Maven.gitignore', 'Mercury.gitignore', 'MetaProgrammingSystem.gitignore', 'nanoc.gitignore', 'Nim.gitignore', 'Node.gitignore', 'Objective-C.gitignore', 'OCaml.gitignore', 'Opa.gitignore', 'opencart.gitignore', 'OracleForms.gitignore', 'Packer.gitignore', 'Perl.gitignore', 'Phalcon.gitignore', 'PlayFramework.gitignore', 'Plone.gitignore', 'Prestashop.gitignore', 'Processing.gitignore', 'PureScript.gitignore', 'Python.gitignore', 'Qooxdoo.gitignore', 'Qt.gitignore', 'R.gitignore', 'Rails.gitignore', 'Raku.gitignore', 'RhodesRhomobile.gitignore', 'ROS.gitignore', 'Ruby.gitignore', 'Rust.gitignore', 'Sass.gitignore', 'Scala.gitignore', 'Scheme.gitignore', 'SCons.gitignore', 'Scrivener.gitignore', 'Sdcc.gitignore', 'SeamGen.gitignore', 'SketchUp.gitignore', 'Smalltalk.gitignore', 'stella.gitignore', 'SugarCRM.gitignore', 'Swift.gitignore', 'Symfony.gitignore', 'SymphonyCMS.gitignore', 'Terraform.gitignore', 'TeX.gitignore', 'Textpattern.gitignore', 'TurboGears2.gitignore', 'Typo3.gitignore', 'Umbraco.gitignore', 'Unity.gitignore', 'UnrealEngine.gitignore', 'VisualStudio.gitignore', 'VVVV.gitignore', 'Waf.gitignore', 'WordPress.gitignore', 'Xojo.gitignore', 'Yeoman.gitignore', 'Yii.gitignore', 'ZendFramework.gitignore', 'Zephir.gitignore')]
        [string[]]$NewContentTemplate,

        [Parameter()]
        [switch]$Readme,

        [Parameter()]
        [string]$Path,

        [Parameter()]
        [string]$Content = 'Repo initialized using ADOPS module.'
    )
 
    $Organization = GetADOPSDefaultOrganization
    
    $Uri = "https://dev.azure.com/$Organization/_apis/git/repositories/$RepositoryId/pushes?api-version=7.2-preview.3"

    if ($Branch -notmatch '^refs/.*') {
        $Branch = 'refs/heads/' + $Branch
    }

    $changes = @()
    
    if ($Readme -or ( [String]::IsNullOrEmpty($Path) -and ($newContentTemplate.Count -eq 0) )) {
        $changes += @{
            changeType = 1
            item = @{path = "/README.md" }
            newContentTemplate = @{
                name = "README.md"
                type = "readme"
            }
        }
    }

    if (-not ([string]::IsNullOrEmpty($Path))) {
        $changes += @{
            changeType = "add"
            item = @{
                path = $Path
            }
            newContent = @{
                content = $Content
                contentType = "rawtext"
            }
        }
    }

    if ($newContentTemplate.Count -eq 1) {
        $changes += @{
            changeType = 1
            item = @{path = "/.gitignore" }
            newContentTemplate = @{
                name = $newContentTemplate[0]
                type = 'gitignore'
            }
        }
    }

    if ($newContentTemplate.Count -gt 1) {
        foreach ($t in $newContentTemplate) {
            $changes += @{
                changeType = 1
                item = @{path = "/$t" }
                newContentTemplate = @{
                    name = $t
                    type = 'gitignore'
                }
            }
        }
    }

    $Body = @{
        commits    = @(
            @{
                comment = $Message
                changes = $changes
            }
        )
        refUpdates = @(
            @{
                name        = $Branch.ToLower()
                oldObjectId = "0000000000000000000000000000000000000000"
            }
        )
    }




    $InvokeSplat = @{
        Uri    = $Uri
        Method = 'Post'
        Body   = $Body | ConvertTo-Json -Compress -Depth 100
    }

    InvokeADOPSRestMethod @InvokeSplat
}