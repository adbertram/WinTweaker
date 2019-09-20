function Get-Tweak {
    [OutputType('string')]
    [CmdletBinding()]
    param
    (
        
    )

    $ErrorActionPreference = 'Stop'

    $tweaksPath = Join-Path -Path ($PSScriptRoot | Split-Path -Parent) -ChildPath 'Tweaks'
    (Get-ChildItem -Path $tweaksPath).BaseName
}