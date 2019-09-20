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
        if (-not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Reliability")) {
            Write-Warning -Message "Enable-ShutdownTracker: Required registry key does not exist."
        } else {
            Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Reliability" -Name "ShutdownReasonOn"
        }
    }

    $startTweakParams = $PSBoundParameters + @{ Code = $code }
    Invoke-Tweak @startTweakParams

}