function Start-Tweak {
    [CmdletBinding(SupportsShouldProcess)]
    param
    (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string[]]$ComputerName,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [scriptblock]$Code,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [switch]$Asynchronous
    )

    $ErrorActionPreference = 'Stop'

    Write-Verbose -Message "Running tweak $(Get-CallingFunctionName -CallStack (Get-PSCallStack))..."

    $icmParams = @{
        ComputerName = $ComputerName
        ScriptBlock  = $Code
    }
    if (-not $Asynchronous.IsPresent) {
        $icmParams.AsJob = $true
    }

    Invoke-Command @icmParams
    
}