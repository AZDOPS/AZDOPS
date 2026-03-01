# ADOPS

This repository contains functions for creating and maintaining Azure DevOps environments using OAuth and simple login without PATs.

This project started out as a hackathon around PowerShell and Pester with the goal to be able to create, update, and remove all or most of the parts we regularly use in our own Azure DevOps environments, in a standardized and easy way.

## Installation

From PSGallery, run:

```PowerShell
Install-Module ADOPS
```

_Or_ download this repo and run `Invoke-build` in it to build your own release

_Or_ download this repo and import from ./source/ folder

## Cmdlets using unsupported Azure DevOps endpoints are not loaded by default

Certain cmdlets use undocumented, non-version-controlled, and/or unsupported REST API endpoints. These require a variable to be set, or the `-Force` switch to be used.

Activate these cmdlets by passing the ArgumentList:
```PowerShell
Import-Module ADOPS -ArgumentList $true
```

Or by setting the `AdopsAllowInsecureApis` variable before importing the module:
```PowerShell
$AdopsAllowInsecureApis = $true
Import-Module ADOPS
```

Using a cmdlet with `-Force`:
```PowerShell
Get-ADOPSTenantPolicy -Force
```

## Bug report and feature requests

If you find a bug or have an idea for a new feature create an issue in the repo. Please have a look and see if a similar issue is already created before submitting.

## Contribution

If you like this module and want to contribute you are very much welcome to do so. Please read our [Contribution Guide](CONTRIBUTING.md) before you start! ❤

We try to maintain high test coverage, and encourage TDD using [Pester](https://github.com/pester/Pester). We will gladly help out if you need help getting started with it.

## Maintainers

This project is currently maintained by the following coders:

- [bjompen](https://github.com/bjompen)
- [JohnRoos](https://github.com/JohnRoos)
- [SebastianClaesson](https://github.com/SebastianClaesson)
