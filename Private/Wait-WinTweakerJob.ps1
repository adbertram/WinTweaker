function Wait-WinTweakerJob {
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [int]$Timeout = 300 ## seconds
    )

    $ErrorActionPreference = 'Stop'

    $winTweakerJobs = Get-Job -Name 'WinTweaker:*'
    $timer = [Diagnostics.Stopwatch]::StartNew()
    while (@($winTweakerJobs).where({ $_.State -eq 'Running' }) -and ($timer.Elapsed.TotalMinutes -lt $Timeout)) {
        $runningJobs = @($winTweakerJobs) | Where-Object { $_.State -eq 'Running' }
        if ($runningJobs) {
            Write-Verbose "Waiting for $(@($runningJobs).Count) WinTweaker jobs to finish..."
            Start-Sleep -Seconds 10
        }
    }
    $timer.Stop()
    if ($timer.Elapsed.TotalMinutes -ge $Timeout) {
        throw 'Timeout exceeded while waiting for WinTweaker jobs.'
    }
}