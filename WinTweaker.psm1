#Requires -Version 5

Set-StrictMode -Version Latest

#region Make functions available and export public functions
# Get public and private function definition files.
$Public = @(Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue)
$Private = @(Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue)
$Tweaks = @(Get-ChildItem -Path $PSScriptRoot\Tweaks\*.ps1 -ErrorAction SilentlyContinue)

# Dot source the files.
foreach ($import in @($Public + $Private + $Tweaks)) {
    try {
        Write-Verbose "Importing $($import.FullName)"
        . $import.FullName
    } catch {
        Write-Error "Failed to import function $($import.FullName): $_"
    }
}

foreach ($file in ($Public + $Tweaks)) {
    Export-ModuleMember -Function $file.BaseName
}
#endregion

#region Create ArgumentCompleter for the Start-Tweaking function
$scriptBlock = {
    Get-Tweak
}
Register-ArgumentCompleter -CommandName Start-Tweaking -ParameterName TweakName -ScriptBlock $scriptBlock
#endregion