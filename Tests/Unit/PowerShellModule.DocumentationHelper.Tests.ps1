$projectRootPath = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
$moduleRootPath = Join-Path -Path $projectRootPath -ChildPath 'PowerShellModule.DocumentationHelper'
$modulePath = Join-Path -Path $moduleRootPath -ChildPath 'WikiPages.psm1'

Import-Module -Name $modulePath -Force

Import-Module -Name (Join-Path -Path (Join-Path -Path (Split-Path $PSScriptRoot -Parent) -ChildPath 'TestHelpers') -ChildPath 'CommonTestHelper.psm1') -Global

InModuleScope -ModuleName 'WikiPages' {

    $script:mockOutputPath = Join-Path -Path $ENV:Temp -ChildPath 'docs'
    $script:mockModulePath = Join-Path -Path $ENV:Temp -ChildPath 'module'

    # Example file info
    $script:mockExampleFilePath = Join-Path -Path $script:mockModulePath -ChildPath '\Examples\Resources\MyResource\MyResource_Example1_Config.ps1'
    $script:expectedExamplePath = Join-Path -Path $script:mockModulePath -ChildPath '\Examples\Resources\MyResource\*.ps1'
    $script:mockExampleFiles = @(
        @{
            Name     = 'MyResource_Example1_Config.ps1'
            FullName = $script:mockExampleFilePath
        }
    )
    $script:mockExampleContent = '### Example 1

Example description.

```powershell
```'

    # General mock values
    $script:mockOutputFile = Join-Path -Path $script:mockOutputPath -ChildPath 'MyResource.md'
    $script:mockGetContentReadme = '
# Description

The description of the resource.
'
    $script:mockWikiPageOutput = ''

    Describe 'PowerShellModule.DocumentationHelper\WikiPages.psm1\New-PowerShellModuleWikiSite' {
        # Parameter filters
        $script:getChildItemExample_parameterFilter = {
            $Path -eq $script:expectedExamplePath
        }
        $script:getTestPathReadme_parameterFilter = {
            $Path -eq $script:mockReadmePath
        }
        $script:getContentReadme_parameterFilter = {
            $Path -eq $script:mockReadmePath
        }
        $script:getPowerShellModuleWikiExampleContent_parameterFilter = {
            $ExamplePath -eq $script:mockExampleFilePath -and $ExampleNumber -eq 1
        }
        $script:outFile_parameterFilter = {
            $FilePath -eq $script:mockOutputFile `
                -and $InputObject -eq $script:mockWikiPageOutput
        }

        # Function call parameters
        $script:newPowerShellModuleWikiSite_parameters = @{
            OutputPath = $script:mockOutputPath
            ModulePath = $script:mockModulePath
            Verbose    = $true
        }
    }

    Describe 'PowerShellModule.DocumentationHelper\WikiPages.psm1\Get-PowerShellModuleWikiExampleContent' {
        # Parameter filters
        $script:getContentExample_parameterFilter = {
            $Path -eq $script:mockExampleFilePath
        }

        Context 'When a path to an example file with .EXAMPLE is passed and example number 1' {
            $script:getPowerShellModuleWikiExampleContent_parameters = @{
                ExamplePath   = $script:mockExampleFilePath
                ExampleNumber = 1
                Verbose       = $true
            }

            $script:mockExampleContent = '### Example 1

Example Description.

```powershell
```'

            $script:mockGetContentExample = '<#
.EXAMPLE
Example Description.
#>
' -split "`r`n"

            BeforeAll {
                Mock `
                    -CommandName Get-Content `
                    -ParameterFilter $script:getContentExample_parameterFilter `
                    -MockWith { $script:mockGetContentExample }
            }

            It 'Should not throw an exception' {
                { $script:result = Get-PowerShellModuleWikiExampleContent @script:getPowerShellModuleWikiExampleContent_parameters } | Should -Not -Throw
            }

            <#
            It 'Should return the expected string' {
                $script:result | Should -Be $script:mockExampleContent
            }

            It 'Should call the expected mocks ' {
                Assert-MockCalled `
                    -CommandName Get-Content `
                    -ParameterFilter $script:getContentExample_parameterFilter `
                    -Exactly -Times 1
            }
            #>
        }

        Context 'When a path to an example file with .DESCRIPTION is passed and example number 2' {
            $script:getPowerShellModuleWikiExampleContent_parameters = @{
                ExamplePath   = $script:mockExampleFilePath
                ExampleNumber = 2
                Verbose       = $true
            }

            $script:mockExampleContent = '### Example 2

Example Description.

```powershell
```'

            $script:mockGetContentExample = '<#
    .DESCRIPTION
    Example Description.
#>
' -split "`r`n"

            BeforeAll {
                Mock `
                    -CommandName Get-Content `
                    -ParameterFilter $script:getContentExample_parameterFilter `
                    -MockWith { $script:mockGetContentExample }
            }

            It 'Should not throw an exception' {
                { $script:result = Get-PowerShellModuleWikiExampleContent @script:getPowerShellModuleWikiExampleContent_parameters } | Should -Not -Throw
            }

            <#
            It 'Should return the expected string' {
                $script:result | Should -Be $script:mockExampleContent
            }

            It 'Should call the expected mocks ' {
                Assert-MockCalled `
                    -CommandName Get-Content `
                    -ParameterFilter $script:getContentExample_parameterFilter `
                    -Exactly -Times 1
            }
            #>
        }

        Context 'When a path to an example file with .SYNOPSIS is passed and example number 3' {
            $script:getPowerShellModuleWikiExampleContent_parameters = @{
                ExamplePath   = $script:mockExampleFilePath
                ExampleNumber = 3
                Verbose       = $true
            }

            $script:mockExampleContent = '### Example 3

Example Description.

```powershell
```'

            $script:mockGetContentExample = '<#
    .SYNOPSIS
    Example Description.
#>
' -split "`r`n"

            BeforeAll {
                Mock `
                    -CommandName Get-Content `
                    -ParameterFilter $script:getContentExample_parameterFilter `
                    -MockWith { $script:mockGetContentExample }
            }

            It 'Should not throw an exception' {
                { $script:result = Get-PowerShellModuleWikiExampleContent @script:getPowerShellModuleWikiExampleContent_parameters } | Should -Not -Throw
            }

            <#
            It 'Should return the expected string' {
                $script:result | Should -Be $script:mockExampleContent
            }

            It 'Should call the expected mocks ' {
                Assert-MockCalled `
                    -CommandName Get-Content `
                    -ParameterFilter $script:getContentExample_parameterFilter `
                    -Exactly -Times 1
            }
            #>
        }

        Context 'When a path to an example file with .SYNOPSIS and #Requires is passed and example number 4' {
            $script:getPowerShellModuleWikiExampleContent_parameters = @{
                ExamplePath   = $script:mockExampleFilePath
                ExampleNumber = 4
                Verbose       = $true
            }

            $script:mockExampleContent = '### Example 4

Example Description.

```powershell
```'

            $script:mockGetContentExample = '#Requires -module MyModule
#Requires -module OtherModule

<#
    .SYNOPSIS
    Example Description.
#>
' -split "`r`n"

            BeforeAll {
                Mock `
                    -CommandName Get-Content `
                    -ParameterFilter $script:getContentExample_parameterFilter `
                    -MockWith { $script:mockGetContentExample }
            }

            It 'Should not throw an exception' {
                { $script:result = Get-PowerShellModuleWikiExampleContent @script:getPowerShellModuleWikiExampleContent_parameters } | Should -Not -Throw
            }

            <#
            It 'Should return the expected string' {
                $script:result | Should -Be $script:mockExampleContent
            }

            It 'Should call the expected mocks ' {
                Assert-MockCalled `
                    -CommandName Get-Content `
                    -ParameterFilter $script:getContentExample_parameterFilter `
                    -Exactly -Times 1
            }
            #>
        }

        Context 'When a path to an example file with .DESCRIPTION, #Requires and PSScriptInfo is passed and example number 5' {
            $script:getPowerShellModuleWikiExampleContent_parameters = @{
                ExamplePath   = $script:mockExampleFilePath
                ExampleNumber = 5
                Verbose       = $true
            }

            $script:mockExampleContent = '### Example 5

Example Description.

```powershell
```'

            $script:mockGetContentExample = '<#PSScriptInfo
.VERSION 1.0.0
.GUID 14b1346a-436a-4f64-af5c-b85119b819b3
.AUTHOR Microsoft Corporation
.COMPANYNAME Microsoft Corporation
.COPYRIGHT
.TAGS DSCConfiguration
.LICENSEURI https://github.com/PowerShell/CertificateDsc/blob/master/LICENSE
.PROJECTURI https://github.com/PowerShell/CertificateDsc
.ICONURI
.EXTERNALMODULEDEPENDENCIES
.REQUIREDSCRIPTS
.EXTERNALSCRIPTDEPENDENCIES
.RELEASENOTES First version.
.PRIVATEDATA 2016-Datacenter,2016-Datacenter-Server-Core
#>

#Requires -module MyModule
#Requires -module OtherModule

<#
    .DESCRIPTION
        Example Description.
#>
' -split "`r`n"

            BeforeAll {
                Mock `
                    -CommandName Get-Content `
                    -ParameterFilter $script:getContentExample_parameterFilter `
                    -MockWith { $script:mockGetContentExample }
            }

            It 'Should not throw an exception' {
                { $script:result = Get-PowerShellModuleWikiExampleContent @script:getPowerShellModuleWikiExampleContent_parameters } | Should -Not -Throw
            }

            <#
            It 'Should return the expected string' {
                $script:result | Should -Be $script:mockExampleContent
            }

            It 'Should call the expected mocks ' {
                Assert-MockCalled `
                    -CommandName Get-Content `
                    -ParameterFilter $script:getContentExample_parameterFilter `
                    -Exactly -Times 1
            }
            #>
        }

        Context 'When a path to an example file with .SYNOPSIS, .DESCRIPTION and PSScriptInfo is passed and example number 6' {
            $script:getPowerShellModuleWikiExampleContent_parameters = @{
                ExamplePath   = $script:mockExampleFilePath
                ExampleNumber = 6
                Verbose       = $true
            }

            $script:mockExampleContent = '### Example 6

Example Synopsis.

Example Description.

```powershell
```'

            $script:mockGetContentExample = '<#PSScriptInfo
.VERSION 1.0.0
.GUID 14b1346a-436a-4f64-af5c-b85119b819b3
.AUTHOR Microsoft Corporation
.COMPANYNAME Microsoft Corporation
.COPYRIGHT
.TAGS DSCConfiguration
.LICENSEURI https://github.com/PowerShell/MyModule/blob/master/LICENSE
.PROJECTURI https://github.com/PowerShell/MyModule
.ICONURI
.EXTERNALMODULEDEPENDENCIES
.REQUIREDSCRIPTS
.EXTERNALSCRIPTDEPENDENCIES
.RELEASENOTES First version.
.PRIVATEDATA tags
#>

<#
    .SYNOPSIS
        Example Synopsis.

    .DESCRIPTION
        Example Description.
#>
' -split "`r`n"

            BeforeAll {
                Mock `
                    -CommandName Get-Content `
                    -ParameterFilter $script:getContentExample_parameterFilter `
                    -MockWith { $script:mockGetContentExample }
            }

            It 'Should not throw an exception' {
                { $script:result = Get-PowerShellModuleWikiExampleContent @script:getPowerShellModuleWikiExampleContent_parameters } | Should -Not -Throw
            }

            <#
            It 'Should return the expected string' {
                $script:result | Should -Be $script:mockExampleContent
            }

            It 'Should call the expected mocks ' {
                Assert-MockCalled `
                    -CommandName Get-Content `
                    -ParameterFilter $script:getContentExample_parameterFilter `
                    -Exactly -Times 1
            }
            #>
        }
    }
}
