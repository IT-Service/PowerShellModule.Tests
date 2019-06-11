<#
    Define enumeration for use by wiki example generation to determine the type of
    block that a text line is within.
#>
if (-not ([System.Management.Automation.PSTypeName]'WikiExampleBlockType').Type)
{
    $typeDefinition = @'
    public enum WikiExampleBlockType
    {
        None,
        PSScriptInfo,
        Configuration,
        ExampleCommentHeader
    }
'@
    Add-Type -TypeDefinition $typeDefinition
}

<#
    .SYNOPSIS
        New-PowerShellModuleWikiSite generates wiki pages that can be uploaded to GitHub to use as
        public documentation for a module.

    .DESCRIPTION
        The New-PowerShellModuleWikiSite cmdlet will output the Markdown files to the specified directory.
        These help files include details on the property types for each resource, as well as a text
        description and examples where they exist.

    .PARAMETER OutputPath
        Where should the files be saved to

    .PARAMETER ModulePath
        The path to the root of the PowerShell module (where the PSD1 file is found, not the folder for
        and individual PowerShell module)

    .EXAMPLE
        New-PowerShellModuleWikiSite -ModulePath C:\repos\SharePointdsc -OutputPath C:\repos\SharePointDsc\en-US

        This example shows how to generate help for a specific module
#>
function New-PowerShellModuleWikiSite
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $OutputPath,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ModulePath
    )

}

<#
    .SYNOPSIS
        This function reads an example file from a resource and converts
        it to markdown for inclusion in a resource wiki file.

    .DESCRIPTION
        The function will read the example PS1 file and convert the
        help header into the description text for the example. It will
        also surround the example configuration with code marks to
        indication it is powershell code.

    .PARAMETER ExamplePath
        The path to the example file.

    .PARAMETER ModulePath
        The number of the example.

    .EXAMPLE
        Get-PowerShellModuleWikiExampleContent -ExamplePath 'C:\repos\NetworkingDsc\Examples\Resources\DhcpClient\1-DhcpClient_EnableDHCP.ps1' -ExampleNumber 1

        Reads the content of 'C:\repos\NetworkingDsc\Examples\Resources\DhcpClient\1-DhcpClient_EnableDHCP.ps1'
        and converts it to markdown in preparation for being added to a resource wiki page.
#>

function Get-PowerShellModuleWikiExampleContent
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ExamplePath,

        [Parameter(Mandatory = $true)]
        [System.Int32]
        $ExampleNumber
    )

    $exampleContent = Get-Content -Path $ExamplePath

    # Use a string builder to assemble the example description and code
    $exampleDescriptionStringBuilder = New-Object -TypeName System.Text.StringBuilder
    $exampleCodeStringBuilder = New-Object -TypeName System.Text.StringBuilder

    <#
        Step through each line in the source example and determine
        the content and act accordingly:
        \<#PSScriptInfo...#\> - Drop block
        \#Requires - Drop Line
        \<#...#\> - Drop .EXAMPLE, .SYNOPSIS and .DESCRIPTION but include all other lines
        Configuration ... - Include entire block until EOF
    #>
    $blockType = [WikiExampleBlockType]::None

    foreach ($exampleLine in $exampleContent)
    {
        Write-Debug -Message ('Processing Line: {0}' -f $exampleLine)

        # Determine the behavior based on the current block type
        switch ($blockType.ToString())
        {
            'PSScriptInfo'
            {
                Write-Debug -Message 'PSScriptInfo Block Processing'

                # Exclude PSScriptInfo block from any output
                if ($exampleLine -eq '#>')
                {
                    Write-Debug -Message 'PSScriptInfo Block Ended'

                    # End of the PSScriptInfo block
                    $blockType = [WikiExampleBlockType]::None
                }
            }

            'ExampleCommentHeader'
            {
                Write-Debug -Message 'ExampleCommentHeader Block Processing'

                # Include all lines in Example Comment Header block except for headers
                $exampleLine = $exampleLine.TrimStart()

                if ($exampleLine -notin ('.SYNOPSIS', '.DESCRIPTION', '.EXAMPLE', '#>'))
                {
                    # Not a header so add this to the output
                    $null = $exampleDescriptionStringBuilder.AppendLine($exampleLine)
                }

                if ($exampleLine -eq '#>')
                {
                    Write-Debug -Message 'ExampleCommentHeader Block Ended'

                    # End of the Example Comment Header block
                    $blockType = [WikiExampleBlockType]::None
                }
            }

            default
            {
                Write-Debug -Message 'Not Currently Processing Block'

                # Check the current line
                if ($exampleLine.TrimStart() -eq '<#PSScriptInfo')
                {
                    Write-Debug -Message 'PSScriptInfo Block Started'

                    $blockType = [WikiExampleBlockType]::PSScriptInfo
                }
                elseif ($exampleLine -match 'Configuration')
                {
                    Write-Debug -Message 'Configuration Block Started'

                    $null = $exampleCodeStringBuilder.AppendLine($exampleLine)
                    $blockType = [WikiExampleBlockType]::Configuration
                }
                elseif ($exampleLine.TrimStart() -eq '<#')
                {
                    Write-Debug -Message 'ExampleCommentHeader Block Started'

                    $blockType = [WikiExampleBlockType]::ExampleCommentHeader
                }
            }
        }
    }

    # Assemble the final output
    $null = $exampleStringBuilder = New-Object -TypeName System.Text.StringBuilder
    $null = $exampleStringBuilder.AppendLine("### Example $ExampleNumber")
    $null = $exampleStringBuilder.AppendLine()
    $null = $exampleStringBuilder.AppendLine($exampleDescriptionStringBuilder)
    $null = $exampleStringBuilder.AppendLine('```powershell')
    $null = $exampleStringBuilder.Append($exampleCodeStringBuilder)
    $null = $exampleStringBuilder.Append('```')

    return $exampleStringBuilder.ToString()
}

Export-ModuleMember -Function New-PowerShellModuleWikiSite
