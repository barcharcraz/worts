$url = "https://github.com/ninja-build/ninja/releases/download/v1.7.1/ninja-win.zip"
$hash = "4221B2CEF768DE64799077BA83CA9CA28E197415A34257ED8D54F93E899AFC4E"
$pkg_variant = "binary"
$pkg_ver "1.7.1"
$pkg_name = "ninja"
Get-WortDefaults
$download = $(Join-Path $download_dir "ninja-win.zip")

Wort-DefaultDownload
Wort-DefaultExtract
function prepare {}
function build {}

function install {
    New-Item -ItemType Directory "$install_dir/bin"
    Copy-Item -Path "$src_dir/ninja*" -Destination "$install_dir/bin" -Force
}

function latest_version {
    Get-GithubVersion "ninja-build/ninja"
}