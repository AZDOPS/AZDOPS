param (
    $OrganizationName = 'DummyOrg'
)

Mock -CommandName GetADOPSHeader -ModuleName ADOPS -MockWith {
    @{
        Header       = @{
            'Authorization' = 'Basic Base64=='
        }
        Organization = $OrganizationName
    }
} -ParameterFilter { $OrganizationName -eq $OrganizationName }
Mock -CommandName GetADOPSHeader -ModuleName ADOPS -MockWith {
    @{
        Header       = @{
            'Authorization' = 'Basic Base64=='
        }
        Organization = $OrganizationName
    }
}