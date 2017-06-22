Param(
    [string]$base = $(Get-Location)
)
$url = "https://github.com/ninja-build/ninja/releases/download/v1.7.1/ninja-win.zip"
$hash = "4221B2CEF768DE64799077BA83CA9CA28E197415A34257ED8D54F93E899AFC4E"

Get-WortDefaults $base "ninja" "1.7.1"
$download = $(Join-Path $download_dir "ninja-win.zip")

function download {
    Invoke-WebRequest $url -OutFile $download
    if((Get-FileHash -Algorithm SHA256 $download).Hash -ne $hash) {
        throw "Error: File {0} failed verification" -f $download
    }
}
function extract {
    Expand-Archive -Path $download -DestinationPath $src_dir
}
function prepare {}
function build {}

function install {
    New-Item -ItemType Directory "$install_dir/bin"
    Copy-Item -Path "$src_dir/ninja.exe" -Destination "$install_dir/bin/ninja.exe" -Force
}