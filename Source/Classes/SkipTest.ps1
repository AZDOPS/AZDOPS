class SkipTest : Attribute {
    [string[]]$TestNames

    SkipTest([string[]]$Name)
    {
        $this.TestNames = $Name
    }
}