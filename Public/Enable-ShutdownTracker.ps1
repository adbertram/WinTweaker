function Enable-ShutdownTracker {
    [CmdletBinding(SupportsShouldProcess)]
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
        [switch]$Wait
    )

    $ErrorActionPreference = 'Stop'

    $code = {
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Reliability" -Name "ShutdownReasonOn"
    }

    $startTweakParams = $PSBoundParameters + @{ Code = $code }
    Start-Tweak @startTweakParams

}