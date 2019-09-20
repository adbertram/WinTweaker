function Remove-RegistryValue {
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string[]]$ComputerName,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [pscredential]$Credential,

        [Parameter(Mandatory)]
        [ValidateDrive('HKLM', 'HKCU', 'HKU', 'HKCR')]
        [ValidateNotNullOrEmpty()]
        [string]$KeyPath,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [switch]$Asynchronous
    )

    $ErrorActionPreference = 'Stop'

    $code = {
        Remove-ItemProperty -Path $args[0] -Name $args[1] -ErrorAction SilentlyContinue
    }

    $strtTweakParams = @{
        ComputerName = $ComputerName
        Code         = $code
        Arguments    = @($KeyPath, $Name)
        Credential   = $Credential
        Asynchronous = $Asynchronous.IsPresent
    }

    Start-Tweak @strtTweakParams
}