Param(
    [string]$base = $(Get-Location)
)
$versions = @{
$url = "https://github.com/aria2/aria2/releases/download/release-1.26.0/aria2-1.26.0-win-64bit-build1.zip"
$hash = "AE6070C5009D4964BA87863C23F8627A9E13C586941054B75B593D3C160AED5A"
}

Get-WortDefaults $base "aria2" "1.26.0"

$download = $(Join-Path $download_dir "aria2-1.26.0")

Wort-DefaultInitialize

Wort-DefaultDownload
WOrt-DefaultExtract

function prepare {}

function build {
    New-Item -ItemType Directory "$build_dir/bin"
    Copy-Item -Path "$src_dir/aria2c.exe" -Destination "$build_dir/bin"
}

function install {
    Copy-Item -Recurse "$build_dir/*" "$install_dir"
}

function latest_version {
    Get-GitHubVersion "aria2/aria2"
}