function Set-RegistryValue {
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

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Value,

        [Parameter()]
        [ValidateSet('Binary', 'DWord', 'ExpandString', 'MultiString', 'QWord', 'String')]
        [ValidateNotNullOrEmpty()]
        [string]$Type,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [switch]$Asynchronous
    )

    $ErrorActionPreference = 'Stop'

    $code = {
        if (-not (Test-Path -Path $args[0])) {
            $null = New-Item -Path $args[0] -Force
        }
        $setParams = @{
            Path  = $args[0]
            Name  = $args[1]
            Value = $args[2]
        }
        if ($args[3]) {
            $setParams.Type = $args[3]
        }
        Set-ItemProperty @setParams
    }

    $strtTweakParams = @{
        ComputerName = $ComputerName
        Code         = $code
        Arguments    = @($KeyPath, $Name, $Value, $Type)
        Credential   = $Credential
        Asynchronous = $Asynchronous.IsPresent
    }

    Start-Tweak @strtTweakParams
}