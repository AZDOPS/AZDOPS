param(
    [Parameter()]
    [ValidateScript({$_ -match '\.psm1$'}, ErrorMessage = 'Please input a PSM1 file')]
    $PSM1 = "$PSScriptRoot\..\Source\ADOPS.psm1"
)

BeforeDiscovery {
    $ModuleName = (get-module $psm1 -ListAvailable).Name
    Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
    
    # Paths
    $PSM1 = (resolve-path $PSM1).Path
    $PSD1 = $PSM1 -replace '.psm1$', '.psd1'
    $ScriptDirectory = Split-Path -Path $PSM1 -Parent
    
    Import-Module $PSD1 -Force
    
    $ModuleName = (get-module $psm1 -ListAvailable).Name
    
    # actual exported functions
    $ExportedFunctions = (Get-Module $ModuleName).ExportedCommands.Keys

    # Get functions supposed to be public
    if (Test-Path -Path "$ScriptDirectory\Public" -PathType Container) {
        $CompiledModule = $false
        # Uncompiled module, check the public folder
        $PublicFiles = Get-Childitem "$ScriptDirectory\Public\*.ps1"
        $PublicFunctions = $PublicFiles.Name -replace '\.ps1$'
    }
    else {
        $CompiledModule = $true
        # Compiled module, check functions that have correct Verb-Noun setup
        # Get all lines from the PSM1 matching "function word-word {"
        $regEx = Get-Item $psm1 | Select-String -Pattern '^function\s{1}(?<FunctionName>[a-zA-Z]+\-[a-zA-Z]+)\s+\{\s*$'
        # Get the word-word part only
        $PublicFunctions = ($regEx.Matches.Groups | Where-Object {$_.Name -eq "FunctionName"}).Value
        # Get only those where first word is approved
        $ApprovedVerbs = (Get-Verb).Verb
        $PublicFunctions = $PublicFunctions.Where({
            ($_ -split '-')[0] -in $ApprovedVerbs
        })
    }
    
    # Set up public testcases
    $PublicTestCases = @()
    $ParametersTestCases = @()
    $ExportedFunctionsTestCases = @()
    
    foreach ($PublicFunction in $PublicFunctions) {
        $PublicTestCases += @{
            Function = $PublicFunction
            ExportedFunctions = $ExportedFunctions
        }
        $Parameters = (Get-Command $PublicFunction).Parameters.GetEnumerator() | Where-Object {
            $_.Key -notin [System.Management.Automation.Cmdlet]::CommonParameters -and
            $_.Value.Attributes.DontShow -eq $false
        } | Select-Object -ExpandProperty Key
        foreach ($Parameter in $Parameters) {
            $ParametersTestCases += @{
                Function = $PublicFunction
                Parameter = $Parameter
            }
        }
    }
    
    foreach ($ExportedFunction in $ExportedFunctions) {
        $ExportedFunctionsTestCases += @{
            ExportedFunction = $ExportedFunction
            PublicFunctions = $PublicFunctions
        }
    }
    
    # Get functions supposed to be private
    if (Test-Path -Path "$ScriptDirectory\Private" -PathType Container) {
        # Uncompiled module, check the public folder
        $PublicFiles = Get-Childitem "$ScriptDirectory\Private\*.ps1"
        $PrivateFunctions = $PublicFiles.Name -replace '\.ps1$'
    }
    else {
        # Compiled module, check functions that does not have correct Verb-Noun setup
        # Get all lines from the PSM1 matching "function words(s) {"
        $regEx = Get-Item $psm1 | Select-String -Pattern '^function\s{1}(?<FunctionName>.+)\s+\{\s*$'
        # Get the function name part only
        $PrivateFunctions = ($regEx.Matches.Groups | Where-Object {$_.Name -eq "FunctionName"}).Value
        # Get only those not in public functions
        $PrivateFunctions = $PrivateFunctions.Where({
            $_ -notin $PublicFunctions
        })
    }
    
    $PrivateTestCases = @()
    foreach ($PrivateFunction in $PrivateFunctions) {
        $PrivateTestCases += @{
            Function = $PrivateFunction
            ExportedFunctions = $ExportedFunctions
        }
    }
}

Describe "Module $ModuleName" {
    
    # A module should always have public functions
    # Its technically possible to not have any public functions. In that case, modify this script.
    Context 'Validate public functions' {
        BeforeEach {
            $ScriptDirectory = Split-Path -Path $PSM1 -Parent
        }

        # Tests run on both uncompiled and compiled modules
        It "Exported functions exist" -TestCases (@{ Count = $PublicTestCases.count }) {
            param ( $Count )
            $Count | Should -BeGreaterThan 0 -Because 'functions should exist'
        }

        # This test will only run on functions that does not have the [SkipTest('HasOrganizationParameter')] attribute set.
        It "Public function '<Function>' should have parameter Organization." -TestCases $PublicTestCases.Where({-Not (Get-Command $_.Function).ScriptBlock.Attributes.Where({$_.TypeID.Name -eq 'SkipTest'}).TestNames -contains 'HasOrganizationParameter'}) {
            param ( $Function )
            Get-Command $Function | Should -HaveParameter 'Organization'
        }

        # Tests only for uncompiled modules goes here
        if (-not $CompiledModule) {
            It "Public function '<Function>' should have a CmdLet file in correct place." -TestCases $PublicTestCases {
                param ( $Function )
                
                Test-Path -Path "$ScriptDirectory\Public\$Function.ps1" -PathType Leaf | Should -Be $true
            }

            It "Public function '<Function>' should have a test file." -TestCases $PublicTestCases {
                param ( $Function )
                
                Test-Path -Path "$ScriptDirectory\..\Tests\$Function.Tests.ps1" -PathType Leaf | Should -Be $true
            }
            
            It "Public function '<Function>' should have a Docs/Help file." -TestCases $PublicTestCases {
                param ( $Function )
                
                Test-Path -Path "$ScriptDirectory\..\Docs\Help\$Function.md" -PathType Leaf | Should -Be $true
            }
            
            It "Public function '<Function>' should not have empty descriptions in help file" -TestCases $PublicTestCases {
                param ( $Function )
                
                Get-ChildItem "$ScriptDirectory\..\Docs\Help\$Function.md" | Select-String '{{ Fill \w+ Description }}' | Should -BeNullOrEmpty
            }

            It "Docs/Help file for '<Function>' contains parameter '<Parameter>'." -TestCases $ParametersTestCases {
                param ( $Function, $Parameter )

                "$ScriptDirectory\..\Docs\Help\$Function.md" | Should -FileContentMatch $Parameter
            }

            It "Parameter '<Parameter>'in function '<Function>' is PascalCase (starts with capital letter)." -TestCases $ParametersTestCases {
                param ( $Function, $Parameter )

                $Parameter | Should -MatchExactly "^[A-Z].*"
            }
        }
        # Tests only for compiled modules goes here
        if ($CompiledModule) {
            It "Public function '<Function>' has been exported" -TestCases $PublicTestCases {
                param ( $Function,  $ExportedFunctions)
                $ExportedFunctions | Should -Contain $Function -Because 'It should be exported'
            }

            It "Exported function '<ExportedFunction>' is supposed to be public" -TestCases $ExportedFunctionsTestCases {
                param ( $ExportedFunction,  $PublicFunctions)

                $ExportedFunction | Should -BeIn $PublicFunctions -Because 'If function is exported but not a public function thats not correct'
            }
        }
    }
<#
    # Only run test cases for private functions if we have any to run
    if ($PrivateTestCases.count -gt 0) {
        Context 'Validate private functions' -skip {
            It "Private function '<Function>' has not been exported" -TestCases $PrivateTestCases {
                param ( $Function,  $ExportedFunctions)
                $ExportedFunctions | Should -Not -Contain $Function -Because 'the file is not in the Public folder'
            }
            It "Private function '<Function>' should have a CmdLet file in correct place." -TestCases $PrivateTestCases {
                param ( $Function )
                Test-Path -Path "$ScriptDirectory\..\Source\Private\$Function.ps1" -PathType Leaf | Should -Be $true
            }
            It "Private function '<Function>' should have a test file." -TestCases $PrivateTestCases {
                param ( $Function )
                Test-Path -Path "$ScriptDirectory\$Function.Tests.ps1" -PathType Leaf | Should -Be $true
            }
        }
    }
#>
}