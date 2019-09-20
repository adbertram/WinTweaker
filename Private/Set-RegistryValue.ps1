function Set-RegistryValue {
    [CmdletBinding()]
    param
    (
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
        [string]$Type
    )

    $ErrorActionPreference = 'Stop'

    if (-not (Test-Path -Path $KeyPath)) {
        $null = New-Item -Path $KeyPath -Force
    }
    $setParams = @{
        Path  = $KeyPath
        Name  = $Name
        Value = $Value
    }
    if ($Type) {
        $setParams.Type = $Type
    }
    Set-ItemProperty @setParams
}