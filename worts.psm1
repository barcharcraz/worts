# Implement your module commands in this script.


# Export only the functions using PowerShell standard verb-noun naming.
# Be sure to list each exported functions in the FunctionsToExport field of the module manifest file.
# This improves performance of command discovery in PowerShell.
Set-StrictMode -Version Latest

function Use-DefaultWortVariables {
    param(
        [string]$name = $(Get-Variable  -Name name -ValueOnly),
        [semver]$version = $(Get-Variable  -Name ver -ValueOnly)
    )
    #echo $PSScriptRoot
    Set-Variable -Name base -Value $(Join-Path $PSScriptRoot "prefix")
    Set-Variable -Name download_dir -Value $(Join-Path $base "download")
    Set-Variable -Name pkg_base -Value $(Join-Path $base "$name-$version")
    Set-Variable -Name src_dir -Value $(Join-Path $pkg_base "src")
    Set-Variable -Name build_dir -Value $(Join-Path $pkg_base "build")
    Set-Variable -Name install_dir -Value $(Join-Path $base "install")
}


Export-ModuleMember -Function *-*

