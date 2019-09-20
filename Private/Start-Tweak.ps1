function Start-Tweak {
    [CmdletBinding(SupportsShouldProcess)]
    param
    (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [scriptblock]$TweakCode
    )

    $ErrorActionPreference = 'Stop'

    
}