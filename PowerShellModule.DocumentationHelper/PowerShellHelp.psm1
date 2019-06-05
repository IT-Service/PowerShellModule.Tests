<#
.SYNOPSIS

New-PowerShellModulePowerShellHelp generates PowerShell compatable help files for a
PowerShell module

.DESCRIPTION

The New-PowerShellModulePowerShellHelp cmdlet will review all of the MOF based resources
in a specified module directory and will inject PowerShell help files for each resource
in to the specified directory. These help files include details on the property types for
each resource, as well as a text description and examples where they exist.

.PARAMETER OutputPath

Where should the files be saved to (ususally the "en-US" folder inside the module for US english)

.PARAMETER ModulePath

The path to the root of the PowerShell module (where the PSD1 file is found, not the folder for
and individual PowerShell module)

.EXAMPLE

This example shows how to generate help for a specific module

    New-PowerShellModulePowerShellHelp -ModulePath C:\repos\MyModule -OutputPath C:\repos\MyModule\en-US

#>
function New-PowerShellModulePowerShellHelp
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $OutputPath,

        [parameter(Mandatory = $true)]
        [System.String]
        $ModulePath
    )

    $output = ''
    $savePath = Join-Path -Path $OutputPath -ChildPath "about_$($result.FriendlyName).help.txt"
    $output | Out-File -FilePath $savePath -Encoding utf8 -Force
}

Export-ModuleMember -Function *
