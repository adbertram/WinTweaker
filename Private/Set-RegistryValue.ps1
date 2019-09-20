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
        [string]$Type
    )

    $ErrorActionPreference = 'Stop'

    if (-not $PSBoundParameters.ContainsKey('ComputerName')) {
        $ComputerName = $env:COMPUTERNAME
    }

    $code = {
        if (-not (Test-Path -Path $KeyPath)) {
            $null = New-Item -Path $KeyPath -Force
        }
        $setParams = @{
            Path  = $KeyPath
            Name  = $Name
            Value = $Value
        }
        if ($PSBoundParameters.ContainsKey('Type')) {
            $setParams.Type = $Type 
        }
        Set-ItemProperty @setParams
    }

    Start-Tweak -ComputerName $ComputerName -Code $code
}