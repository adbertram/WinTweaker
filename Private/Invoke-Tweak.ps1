function Invoke-Tweak {
    [CmdletBinding(SupportsShouldProcess)]
    param
    (
        [Parameter()]
        [string[]]$ComputerName,

        [Parameter()]
        [pscredential]$Credential,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [scriptblock]$Code,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [switch]$Wait,

        [Parameter()]
        [object[]]$Arguments
    )

    $ErrorActionPreference = 'Stop'

    $tweakName = Get-CallingFunctionName -CallStack (Get-PSCallStack)
    Write-Verbose -Message "Running tweak $tweakName..."

    $icmParams = @{
        ScriptBlock = $Code
    }

    if (-not $ComputerName) {
        $ComputerName = $env:COMPUTERNAME
    }
    $icmParams.ComputerName = $ComputerName

    if (-not $Wait.IsPresent) {
        $icmParams.AsJob = $true
        $icmParams.JobName = "WinTweaker: $ComputerName - $tweakName"
    }

    if ($Credential) {
        $icmParams.Credential = $Credential
    }

    if ($Arguments) {
        $icmParams.ArgumentList = $Arguments
    }

    Invoke-Command @icmParams
}