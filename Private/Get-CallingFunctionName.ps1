function Get-CallingFunctionName {
    [OutputType('string')]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.CallStackFrame]$CallStack
    )

    $ErrorActionPreference = 'Stop'

    $CallStack[0].Command
}