@{
    RootModule        = 'WinSrvTweaker.psm1'
    ModuleVersion     = '*'
    GUID              = 'a8e33cfd-4dc6-493b-bdcf-26df80f2c1d5'
    Author            = 'Adam Bertram'
    CompanyName       = 'Adam the Automator, LLC'
    Copyright         = '(c) 2017 Adam Bertram. All rights reserved.'
    Description       = 'Allows a way to quickly apply tweaks to Windows Server'
    PowerShellVersion = '5.1'
    FunctionsToExport = '*'
    CmdletsToExport   = '*'
    VariablesToExport = '*'
    AliasesToExport   = '*'
    PrivateData       = @{
        PSData = @{
            Tags       = @('PSModule', 'WindowsServer')
            ProjectUri = 'https://github.com/adbertram/WinTweaker'
        }
    }
}
