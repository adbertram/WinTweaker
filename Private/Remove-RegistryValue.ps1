function Remove-RegistryValue {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateDrive('HKLM', 'HKCU', 'HKU', 'HKCR')]
        [ValidateNotNullOrEmpty()]
        [string]$KeyPath,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Name
    )

    $ErrorActionPreference = 'Stop'

    Remove-ItemProperty -Path $KeyPath -Name $Name
}