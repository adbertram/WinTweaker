function Start-Tweaking {
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$ComputerName,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [pscredential]$Credential,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string[]]$TweakName,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [switch]$Wait
    )

    $ErrorActionPreference = 'Stop'

    $whereFilter = { '*' }
    if ($PSBoundParameters.ContainsKey('TweakName')) {
        $whereFilter = { $_ -in $TweakName }
    }

    $tweakParams = @{
        Wait = $Wait.IsPresent
    }
    if ($PSBoundParameters.ContainsKey('')) {
        $tweakParams.ComputerName = $ComputerName        
    }
    if ($PSBoundParameters.ContainsKey('Credential')) {
        $tweakParams.Credential = $Credential
    }

    (Get-Tweak).where($whereFilter).foreach({
            & $_ @tweakParams
        })
}