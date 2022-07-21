<#
    This test suite checks that the correct functions are exported from a module.
    Only functions located in the Public folder should be exported.
#>

#region Set up test cases
$ScriptDirectory = Split-Path -Path $PSCommandPath -Parent

# actual exported functions
$ExportedFunctions = (Get-Module -FullyQualifiedName "$ScriptDirectory\..\Source\ADOPS.psd1" -ListAvailable -Refresh).ExportedFunctions.Keys
$ModuleName = (Get-ChildItem -Path "$ScriptDirectory\..\Source\ADOPS.psm1").BaseName

# Create test cases for public functions
if (Test-Path -Path "$ScriptDirectory\..\Source\Public" -PathType Container) {
    $PublicFiles = Get-Childitem "$ScriptDirectory\..\Source\Public\*.ps1"
    $PublicFunctions = $PublicFiles.Name -replace '\.ps1$'

    $PublicTestCases = @()
    $ParametersTestCases = @()
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
}

# Create test cases for private functions
if (Test-Path -Path "$ScriptDirectory\..\Source\Private" -PathType Container) {
    $PrivateFiles = Get-Childitem "$ScriptDirectory\..\Source\Private\*.ps1"
    $PrivateFunctions = $PrivateFiles.Name -replace '\.ps1$'

    $PrivateTestCases = @()
    foreach ($PrivateFunction in $PrivateFunctions) {
        $PrivateTestCases += @{
            Function = $PrivateFunction
            ExportedFunctions = $ExportedFunctions
        }
    }
}

# Import the module files before starting tests
BeforeAll {
    $ScriptDirectory = Split-Path -Path $PSCommandPath -Parent
    Import-Module -FullyQualifiedName "$ScriptDirectory\..\Source\ADOPS.psd1" -ErrorAction Stop
}

Describe "Module $ModuleName" {
    
    # A module should always have public functions
    # Its technically possible to not have any public functions. In that case, modify this script.
    Context 'Validate public functions' {
        
        It "Exported functions exist" -TestCases (@{ Count = $PublicTestCases.count }) {
            param ( $Count )
            $Count | Should -BeGreaterThan 0 -Because 'functions should exist'
        }

        # This test will only run on functions that does not have the [SkipTest('HasOrganizationParameter')] attribute set.
        It "Public function '<Function>' should have parameter Organization." -TestCases $PublicTestCases.Where({-Not (Get-Command $_.Function).ScriptBlock.Attributes.Where({$_.TypeID.Name -eq 'SkipTest'}).TestNames -contains 'HasOrganizationParameter'}) {
            param ( $Function )
            (Get-Command $Function).Parameters.Keys | Should -Contain 'Organization'
        }
        It "Public function '<Function>' should have a CmdLet file in correct place." -TestCases $PublicTestCases {
            param ( $Function )
            Test-Path -Path "$ScriptDirectory\..\Source\Public\$Function.ps1" -PathType Leaf | Should -Be $true
        }
        It "Public function '<Function>' should have a test file." -TestCases $PublicTestCases {
            param ( $Function )
            Test-Path -Path "$ScriptDirectory\$Function.Tests.ps1" -PathType Leaf | Should -Be $true
        }
        It "Public function '<Function>' should have a Docs/Help file." -TestCases $PublicTestCases {
            param ( $Function )
            Test-Path -Path "$ScriptDirectory\..\Docs\Help\$Function.md" -PathType Leaf | Should -Be $true
        }
        It "Docs/Help file for '<Function>' contains parameter '<Parameter>'." -TestCases $ParametersTestCases {
            param ( $Function, $Parameter )
            "$ScriptDirectory\..\Docs\Help\$Function.md" | Should -FileContentMatch $Parameter
        }

        # This test only works on compiled psd1 files, and can tbe run in current build script. needs to be revisited.
        # It "Public function '<Function>' has been exported" -TestCases $PublicTestCases {
        #     param ( $Function,  $ExportedFunctions)
        #     $ExportedFunctions | Should -Contain $Function -Because 'the file is in the Public folder'
        # }
    }

    # Only run test cases for private functions if we have any to run
    if ($PrivateTestCases.count -gt 0) {
        Context 'Validate private functions' {
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

}