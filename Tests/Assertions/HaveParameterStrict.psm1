# Adapted from https://github.com/pester/Pester/blob/5.3.3/src/functions/assertions/HaveParameter.ps1
# Replaced \$SafeCommands\['([\w-]*)'\] with $1

#region Dependent functions
function Format-Because ([string] $Because) {
    if ($null -eq $Because) {
        return
    }

    $bcs = $Because.Trim()
    if ([string]::IsNullOrEmpty($bcs)) {
        return
    }

    " because $($bcs -replace 'because\s'),"
}
function Format-Collection ($Value, [switch]$Pretty) {
    $Limit = 10
    $separator = ', '
    if ($Pretty) {
        $separator = ",`n"
    }
    $count = $Value.Count
    $trimmed = $count -gt $Limit

    $formattedCollection = @()
    for ($i = 0; $i -lt [System.Math]::Min($count, $Limit); $i++) {
        $formattedValue = Format-Nicely -Value $Value[$i] -Pretty:$Pretty
        $formattedCollection += $formattedValue
    }

    '@(' + ($formattedCollection -join $separator) + $(if ($trimmed) { ", ...$($count - $limit) more" }) + ')'
}

function Format-Object ($Value, $Property, [switch]$Pretty) {
    if ($null -eq $Property) {
        $Property = $Value.PSObject.Properties | & Select-Object -ExpandProperty Name
    }
    $valueType = Get-ShortType $Value
    $valueFormatted = ([string]([PSObject]$Value | & Select-Object -Property $Property))

    if ($Pretty) {
        $margin = "    "
        $valueFormatted = $valueFormatted `
            -replace '^@{', "@{`n$margin" `
            -replace '; ', ";`n$margin" `
            -replace '}$', "`n}" `

    }

    $valueFormatted -replace "^@", $valueType
}

function Format-Null {
    '$null'
}

function Format-String ($Value) {
    if ('' -eq $Value) {
        return '<empty>'
    }

    "'$Value'"
}

function Format-Date ($Value) {
    $Value.ToString('o')
}

function Format-Boolean ($Value) {
    '$' + $Value.ToString().ToLower()
}

function Format-ScriptBlock ($Value) {
    '{' + $Value + '}'
}

function Format-Number ($Value) {
    [string]$Value
}

function Format-Hashtable ($Value) {
    $head = '@{'
    $tail = '}'

    $entries = $Value.Keys | & Sort-Object | & ForEach-Object {
        $formattedValue = Format-Nicely $Value.$_
        "$_=$formattedValue" }

    $head + ( $entries -join '; ') + $tail
}

function Format-Dictionary ($Value) {
    $head = 'Dictionary{'
    $tail = '}'

    $entries = $Value.Keys | & Sort-Object | & ForEach-Object {
        $formattedValue = Format-Nicely $Value.$_
        "$_=$formattedValue" }

    $head + ( $entries -join '; ') + $tail
}

function Format-Nicely ($Value, [switch]$Pretty) {
    if ($null -eq $Value) {
        return Format-Null -Value $Value
    }

    if ($Value -is [bool]) {
        return Format-Boolean -Value $Value
    }

    if ($Value -is [string]) {
        return Format-String -Value $Value
    }

    if ($Value -is [DateTime]) {
        return Format-Date -Value $Value
    }

    if ($value -is [Type]) {
        return '[' + (Format-Type -Value $Value) + ']'
    }

    if (Is-DecimalNumber -Value $Value) {
        return Format-Number -Value $Value
    }

    if (Is-ScriptBlock -Value $Value) {
        return Format-ScriptBlock -Value $Value
    }

    if (Is-Value -Value $Value) {
        return $Value
    }

    if (Is-Hashtable -Value $Value) {
        # no advanced formatting of objects in the first version, till I balance it
        return [string]$Value
        #return Format-Hashtable -Value $Value
    }

    if (Is-Dictionary -Value $Value) {
        # no advanced formatting of objects in the first version, till I balance it
        return [string]$Value
        #return Format-Dictionary -Value $Value
    }

    if (Is-Collection -Value $Value) {
        return Format-Collection -Value $Value -Pretty:$Pretty
    }

    # no advanced formatting of objects in the first version, till I balance it
    return [string]$Value
    # Format-Object -Value $Value -Property (Get-DisplayProperty $Value) -Pretty:$Pretty
}

function Sort-Property ($InputObject, [string[]]$SignificantProperties, $Limit = 4) {

    $properties = @($InputObject.PSObject.Properties |
            & Where-Object { $_.Name -notlike "_*" } |
            & Select-Object -expand Name |
            & Sort-Object)
    $significant = @()
    $rest = @()
    foreach ($p in $properties) {
        if ($significantProperties -contains $p) {
            $significant += $p
        }
        else {
            $rest += $p
        }
    }

    #todo: I am assuming id, name properties, so I am just sorting the selected ones by name.
    (@($significant | & Sort-Object) + $rest) | & Select-Object -First $Limit

}

function Get-DisplayProperty ($Value) {
    Sort-Property -InputObject $Value -SignificantProperties 'id', 'name'
}

function Get-ShortType ($Value) {
    if ($null -ne $value) {
        $type = Format-Type $Value.GetType()
        # PSCustomObject serializes to the whole type name on normal PS but to
        # just PSCustomObject on PS Core

        $type `
            -replace "^System\." `
            -replace "^Management\.Automation\.PSCustomObject$", "PSObject" `
            -replace "^PSCustomObject$", "PSObject" `
            -replace "^Object\[\]$", "collection" `

    }
    else {
        Format-Type $null
    }
}

function Format-Type ([Type]$Value) {
    if ($null -eq $Value) {
        return '<none>'
    }

    [string]$Value
}

function Join-And ($Items, $Threshold = 2) {

    if ($null -eq $items -or $items.count -lt $Threshold) {
        $items -join ', '
    }
    else {
        $c = $items.count
        ($items[0..($c - 2)] -join ', ') + ' and ' + $items[-1]
    }
}

function Add-SpaceToNonEmptyString ([string]$Value) {
    if ($Value) {
        " $Value"
    }
}
#endregion

function Should-HaveParameterStrict (
    $ActualValue,
    [String] $ParameterName,
    $Type,
    [String]$DefaultValue,
    [Switch]$Mandatory,
    [Switch]$HasArgumentCompleter,
    [String]$Alias,
    [Switch]$Negate,
    [String]$Because ) {
    <#
    .SYNOPSIS
        Asserts that a command has the expected parameter.

    .EXAMPLE
        Get-Command "Invoke-WebRequest" | Should -HaveParameterStrict Uri -Mandatory

        This test passes, because it expected the parameter URI to exist and to
        be mandatory.
    .NOTES
        The attribute [ArgumentCompleter] was added with PSv5. Previouse this
        assertion will not be able to use the -HasArgumentCompleter parameter
        if the attribute does not exist.
    #>
    if ($null -eq $ActualValue -or $ActualValue -isnot [Management.Automation.CommandInfo]) {
        throw "Input value must be non-null CommandInfo object. You can get one by calling Get-Command."
    }

    if ($null -eq $ParameterName) {
        throw "The ParameterName can't be empty"
    }

    function Get-ParameterInfo {
        param(
            [Parameter( Mandatory = $true )]
            [Management.Automation.CommandInfo]$Command
        )
        <#
        .SYNOPSIS
            Use Tokenize to get information about the parameter block of a command
        .DESCRIPTION
            In order to get information about the parameter block of a command,
            several tools can be used (Get-Command, AST, etc).
            In order to get the default value of a parameter, AST is the easiest
            way to go; but AST was only introduced with PSv3.
            This function creates an object with information about parameters
            using the Tokenize
        .NOTES
            Author: Chris Dent
        #>

        function Get-TokenGroup {
            param(
                [Parameter( Mandatory = $true )]
                [System.Management.Automation.PSToken[]]$tokens
            )
            $i = $j = 0
            do {
                $token = $tokens[$i]
                if ($token.Type -eq 'GroupStart') {
                    $j++
                }
                if ($token.Type -eq 'GroupEnd') {
                    $j--
                }
                if (-not $token.PSObject.Properties.Item('Depth')) {
                    $token.PSObject.Properties.Add([Pester.Factory]::CreateNoteProperty("Depth", $j))
                }
                $token

                $i++
            } until ($j -eq 0 -or $i -ge $tokens.Count)
        }

        $errors = $null
        $tokens = [System.Management.Automation.PSParser]::Tokenize($Command.Definition, [Ref]$errors)

        # Find param block
        $start = $tokens.IndexOf(($tokens | & Where-Object { $_.Content -eq 'param' } | & Select-Object -First 1)) + 1
        $paramBlock = Get-TokenGroup $tokens[$start..($tokens.Count - 1)]

        for ($i = 0; $i -lt $paramBlock.Count; $i++) {
            $token = $paramBlock[$i]

            if ($token.Depth -eq 1 -and $token.Type -eq 'Variable') {
                $paramInfo = & New-Object PSObject -Property @{
                    Name = $token.Content
                } | & Select-Object Name, Type, DefaultValue, DefaultValueType

                if ($paramBlock[$i + 1].Content -ne ',') {
                    $value = $paramBlock[$i + 2]
                    if ($value.Type -eq 'GroupStart') {
                        $tokenGroup = Get-TokenGroup $paramBlock[($i + 2)..($paramBlock.Count - 1)]
                        $paramInfo.DefaultValue = [String]::Join('', ($tokenGroup | & ForEach-Object { $_.Content }))
                        $paramInfo.DefaultValueType = 'Expression'
                    }
                    else {
                        $paramInfo.DefaultValue = $value.Content
                        $paramInfo.DefaultValueType = $value.Type
                    }
                }
                if ($paramBlock[$i - 1].Type -eq 'Type') {
                    $paramInfo.Type = $paramBlock[$i - 1].Content
                }
                $paramInfo
            }
        }
    }

    function Get-ArgumentCompleter {
        <#
        .SYNOPSIS
            Get custom argument completers registered in the current session.
        .DESCRIPTION
            Get custom argument completers registered in the current session.

            By default Get-ArgumentCompleter lists all of the completers registered in the session.
        .EXAMPLE
            Get-ArgumentCompleter

            Get all of the argument completers for PowerShell commands in the current session.
        .EXAMPLE
            Get-ArgumentCompleter -CommandName Invoke-ScriptAnalyzer

            Get all of the argument completers used by the Invoke-ScriptAnalyzer command.
        .EXAMPLE
            Get-ArgumentCompleter -Native

            Get all of the argument completers for native commands in the current session.
        .NOTES
            Author: Chris Dent
        #>
        [CmdletBinding()]
        param (
            # Filter results by command name.
            [Parameter(Mandatory = $true)]
            [String]$CommandName,

            # Filter results by parameter name.
            [Parameter(Mandatory = $true)]
            [String]$ParameterName
        )

        $getExecutionContextFromTLS = [PowerShell].Assembly.GetType('System.Management.Automation.Runspaces.LocalPipeline').GetMethod(
            'GetExecutionContextFromTLS',
            [System.Reflection.BindingFlags]'Static, NonPublic'
        )
        $internalExecutionContext = $getExecutionContextFromTLS.Invoke(
            $null,
            [System.Reflection.BindingFlags]'Static, NonPublic',
            $null,
            $null,
            $PSCulture
        )

        $argumentCompletersProperty = $internalExecutionContext.GetType().GetProperty(
            'CustomArgumentCompleters',
            [System.Reflection.BindingFlags]'NonPublic, Instance'
        )
        $argumentCompleters = $argumentCompletersProperty.GetGetMethod($true).Invoke(
            $internalExecutionContext,
            [System.Reflection.BindingFlags]'Instance, NonPublic, GetProperty',
            $null,
            @(),
            $PSCulture
        )

        $completerName = '{0}:{1}' -f $CommandName, $ParameterName
        if ($argumentCompleters.ContainsKey($completerName)) {
            [PSCustomObject]@{
                CommandName   = $CommandName
                ParameterName = $ParameterName
                Definition    = $argumentCompleters[$completerName]
            }
        }
    }

    if ($Type -is [string]) {
        # parses type that is provided as a string in brackets (such as [int])
        $parsedType = ($Type -replace '^\[(.*)\]$', '$1') -as [Type]
        if ($null -eq $parsedType) {
            throw [ArgumentException]"Could not find type [$ParsedType]. Make sure that the assembly that contains that type is loaded."
        }

        $Type = $parsedType
    }
    #endregion HelperFunctions

    $buts = @()
    $filters = @()

    $null = $ActualValue.Parameters # necessary for PSv2
    $hasKey = $ActualValue.Parameters.PSBase.ContainsKey($ParameterName)
    $filters += "to$(if ($Negate) {" not"}) have a parameter $ParameterName"

    if (-not $Negate -and -not $hasKey) {
        $buts += "the parameter is missing"
    }
    elseif ($Negate -and -not $hasKey) {
        return & New-Object PSObject -Property @{ Succeeded = $true }
    }
    elseif ($Negate -and $hasKey -and -not ($Mandatory -or $Type -or $DefaultValue -or $HasArgumentCompleter)) {
        $buts += "the parameter exists"
    }
    else {
        $attributes = $ActualValue.Parameters[$ParameterName].Attributes

        #region STRICTER -Mandatory:$false check
        if (-not $Mandatory -and $PSBoundParameters.Keys -contains "Mandatory") {
            $testMandatory = $attributes | & Where-Object { $_ -is [System.Management.Automation.ParameterAttribute] -and $_.Mandatory }
            $filters += "which is$(if (-not $Negate) {" not"}) mandatory"

            if ($Negate -and -not $testMandatory) {
                $buts += "it wasn't mandatory"
            }
            elseif (-not $Negate -and $testMandatory) {
                $buts += "it was mandatory"
            }
        }
        #endregion

        if ($Mandatory) {
            $testMandatory = $attributes | & Where-Object { $_ -is [System.Management.Automation.ParameterAttribute] -and $_.Mandatory }
            $filters += "which is$(if ($Negate) {" not"}) mandatory"

            if (-not $Negate -and -not $testMandatory) {
                $buts += "it wasn't mandatory"
            }
            elseif ($Negate -and $testMandatory) {
                $buts += "it was mandatory"
            }
        }

        if ($Type) {
            # This block is not using `Format-Nicely`, as in PSv2 the output differs. Eg:
            # PS2> [System.DateTime]
            # PS5> [datetime]
            [type]$actualType = $ActualValue.Parameters[$ParameterName].ParameterType
            $testType = ($Type -eq $actualType)
            $filters += "$(if ($Negate) { "not " })of type [$($Type.FullName)]"

            if (-not $Negate -and -not $testType) {
                $buts += "it was of type [$($actualType.FullName)]"
            }
            elseif ($Negate -and $testType) {
                $buts += "it was of type [$($Type.FullName)]"
            }
        }

        if ($PSBoundParameters.Keys -contains "DefaultValue") {
            $parameterMetadata = Get-ParameterInfo $ActualValue | & Where-Object { $_.Name -eq $ParameterName }
            $actualDefault = if ($parameterMetadata.DefaultValue) { $parameterMetadata.DefaultValue } else { "" }
            $testDefault = ($actualDefault -eq $DefaultValue)
            $filters += "the default value$(if ($Negate) {" not"}) to be $(Format-Nicely $DefaultValue)"

            if (-not $Negate -and -not $testDefault) {
                $buts += "the default value was $(Format-Nicely $actualDefault)"
            }
            elseif ($Negate -and $testDefault) {
                $buts += "the default value was $(Format-Nicely $DefaultValue)"
            }
        }

        if ($HasArgumentCompleter) {
            $testArgumentCompleter = $attributes | & Where-Object { $_ -is [ArgumentCompleter] }

            if (-not $testArgumentCompleter) {
                $testArgumentCompleter = Get-ArgumentCompleter -CommandName $ActualValue.Name -ParameterName $ParameterName
            }
            $filters += "has ArgumentCompletion"

            if (-not $Negate -and -not $testArgumentCompleter) {
                $buts += "has no ArgumentCompletion"
            }
            elseif ($Negate -and $testArgumentCompleter) {
                $buts += "has ArgumentCompletion"
            }
        }

        if ($Alias) {
            $testPresenceOfAlias = $ActualValue.Parameters[$ParameterName].Aliases -contains $Alias
            $filters += "to$(if ($Negate) {" not"}) have an alias '$Alias'"

            if (-not $Negate -and -not $testPresenceOfAlias) {
                $buts += "it didn't have an alias '$Alias'"
            }
            elseif ($Negate -and $testPresenceOfAlias) {
                $buts += "it had an alias '$Alias'"
            }
        }
    }

    if ($buts.Count -ne 0) {
        $filter = Add-SpaceToNonEmptyString ( Join-And $filters -Threshold 3 )
        $but = Join-And $buts
        $failureMessage = "Expected command $($ActualValue.Name)$filter,$(Format-Because $Because) but $but."

        return & New-Object PSObject -Property @{
            Succeeded      = $false
            FailureMessage = $failureMessage
        }
    }
    else {
        return & New-Object PSObject -Property @{ Succeeded = $true }
    }
}

Add-ShouldOperator -Name HaveParameterStrict `
    -InternalName Should-HaveParameterStrict `
    -Test         ${function:Should-HaveParameterStrict}
