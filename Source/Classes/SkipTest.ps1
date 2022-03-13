Class SkipTest : Attribute {
    [string]$TestName

    SkipTest([string[]]$Name)
    {
        $this.TestName = $Name
    }
}