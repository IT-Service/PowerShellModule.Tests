@{
    # Version number of this module.
    ModuleVersion     = '1.0.0.0'

    # ID used to uniquely identify this module
    GUID              = 'ddc502d5-3280-4395-9b0a-724973194aa6'

    # Author of this module
    Author            = 'Sergei S. Betke'

    # Company or vendor of this module
    CompanyName       = 'ФБУ "Тест-С.-Петербург"'

    # Copyright statement for this module
    Copyright         = '(c) 2019 Sergei S. Betke. All rights reserved.'

    # Description of the functionality provided by this module
    Description       = 'This module is used to assist in publish configurations to PowerShell Gallery for PowerShell PowerShell modules.'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '4.0'

    # Cmdlets to export from this module
    CmdletsToExport   = @(
        'Start-GalleryDeploy'
    )

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData       = @{

        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags         = @('PowerShellModuleKit', 'PowerShellModule')

            # A URL to the license for this module.
            LicenseUri   = 'https://github.com/IT-Service/PowerShell/PowerShellModule.Tests/blob/master/LICENSE'

            # A URL to the main website for this project.
            ProjectUri   = 'https://github.com/IT-Service/PowerShellModule.Tests'

            # A URL to an icon representing this module.
            # IconUri = ''

            # ReleaseNotes of this module
            ReleaseNotes = ''

        } # End of PSData hashtable

    } # End of PrivateData hashtable
}

