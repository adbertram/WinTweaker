function Start-Tweak {
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
        [switch]$Asynchronous,

        [Parameter()]
        [object[]]$Arguments
    )

    $ErrorActionPreference = 'Stop'

    Write-Verbose -Message "Running tweak $(Get-CallingFunctionName -CallStack (Get-PSCallStack))..."

    $icmParams = @{
        ScriptBlock = $Code
    }

    if (-not $ComputerName) {
        $ComputerName = $env:COMPUTERNAME
    }
    $icmParams.ComputerName = $ComputerName

    if (-not $Asynchronous.IsPresent) {
        $icmParams.AsJob = $true
    }

    if ($Credential) {
        $icmParams.Credential = $Credential
    }

    if ($Arguments) {
        $icmParams.ArgumentList = $Arguments
    }

    Invoke-Command @icmParams
}