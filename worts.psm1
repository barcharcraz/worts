# Implement your module commands in this script.


# Export only the functions using PowerShell standard verb-noun naming.
# Be sure to list each exported functions in the FunctionsToExport field of the module manifest file.
# This improves performance of command discovery in PowerShell.
using module '.\lib\types.psm1'
Set-StrictMode -Version Latest

function Initialize-WortPackage {
    param(
        [string]$Name = $Name,
        [semver]$Version = $Version
    )
    #echo $PSScriptRoot
    $name = $Name
    $version = $Version
    $base = $(Join-Path $PSScriptRoot "prefix")
    $download_dir = $(Join-Path $base "download")
    $download = $(Join-Path $download_dir / "$Name-$Version")
    $pkg_base = $(Join-Path $base "$name-$version")
    $src_dir = $(Join-Path $pkg_base "src")
    $build_dir = $(Join-Path $pkg_base "build")
    $install_dir = $(Join-Path $base "install")

}
function curl_download($filename, $url) {
    # avoid calling the iwr alias
    $curl = Get-Command -CommandType Application -Name curl
    & $curl -L --progress-bar -o $filename $url
}
function Use-DefaultDownload {
    function download {
        script:curl_download $download_dir $url
    }

}



