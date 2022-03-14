# Contributing to ADOPS

You are more than welcome to contribute to the ADOPS module, whether it is [Pull Requests](#pull-requests), [Feature Suggestions](#feature-suggestions) or [Bug Reports](#bug-reports)!

## Getting Started

- Fork this repo (see [this forking guide](https://guides.github.com/activities/forking/) for more information).
- Checkout the repo locally with `git clone git@github.com:{your_username}/ADOPS.git`.
- If you haven't already, you will need the [PlatyPs](https://github.com/PowerShell/platyPS) PowerShell Module to generate command help and docs.

## Developing

### Structure

The repo is organized as below:

- **Private** (`Source/Private`): All private functions used by the module.
- **Public** (`Source/Public`): All functions exported by the module.
- **Classes** (`Source/Classes`): All classes by the module.
- **Tests** (`Tests`): Pester tests executed at Pull Request.
- **Help** (`Docs\Help`): Markdown help files for external help.

### Running the module locally

- Import the module:

```powershell
Import-Module .\Source\ADOPS.psd1
```

### Tests

The ADOPS module is developed using Test-driven development(TDD) where we aim for full test coverage for all our functions. Make sure that all new features and updates are covered by Pester tests. All tests will be executed when a Pull Request is submitted as a build validation step. PRs with failing tests will not be approved.

[Pester](https://github.com/pester/Pester) is the ubiquitous test and mock framework for PowerShell.

Exclusion of standard tests can be done using the SkipTest attribute (See f.eg New-ADOPSElasticPoolObject)

```PowerShell
[SkipTest('HasOrganizationParameter')]
```

Introducing additional exclusions should be discussed in a GitHub issue before implemention.

### platyPS

[platyPS](https://github.com/PowerShell/platyPS) is used to write the external help in markdown. When contributing always make sure that the changes are added to the help file.

#### Quickstart

- Install the platyPS module from the [PowerShell Gallery](https://powershellgallery.com):

```powershell
Install-Module -Name platyPS -Scope CurrentUser
Import-Module platyPS
```

- Create initial Markdown help file for `ADOPS` module (This will only create help files for new commands, existing files will not be overwritten):

```powershell
# you should have module imported in the session
Import-Module .\Source\ADOPS.psd1
New-MarkdownHelp -Command My-NewCommand -OutputFolder .\Docs\Help
```

Edit the markdown file(s) in the `.\Docs\Help` folder and populate `{{ ... }}` placeholders with missed help content.

- If you've made a lot of changes to the module code, you can easily update the markdown file(s) automatically with:

```powershell
# re-import your module with latest changes
Import-Module .\Source\ADOPS.psd1 -Force
Update-MarkdownHelp .\Docs\Help
```

## Pull Requests

If you like to start contributing to the ADOPS module. Please make sure that there is a related issue to link to your PR.

- Make sure that the issue is tagged in the PR, e.g. "fixes #45"
- Write a short but informative commit message, it will be added to the release notes.

## Feature Suggestions

- Please first search [Open Issues](https://github.com/ADOPS/ADOPS/issues) before opening an issue to check whether your feature has already been suggested. If it has, feel free to add your own comments to the existing issue.
- Ensure you have included a "What?" - what your feature entails, being as specific as possible, and giving mocked-up syntax examples where possible.
- Ensure you have included a "Why?" - what the benefit of including this feature will be.
- Use the "Feature Request" issue template [here](https://github.com/ADOPS/ADOPS/issues/new/choose) to submit your request.

## Bug Reports

- Please first search [Open Issues](https://github.com/ADOPS/ADOPS/issues) before opening an issue, to see if it has already been reported.
- Try to be as specific as possible, including the version of the ADOPS PowerShell module, PowerShell version and OS used to reproduce the issue, and any example files or snippets of ADOPS code needed to reproduce it.
- Use the "Bug Report" issue template [here](https://github.com/ADOPS/ADOPS/issues/new/choose) to submit your request.
