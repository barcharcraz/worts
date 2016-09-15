Param(
    [string]$base = $(Get-Location)
)
$url = "http://www.codesynthesis.com/download/odb/2.4/odb-2.4.0-i686-windows.zip"
$hash = "sha-256=771337A18FA9E5253A7775CC6645A193398B9F7C424B3B631686BBD948C4C499"

Get-WortDefaults $base "odb" "2.4.0"
Wort-AriaDownload
Wort-DefaultExtract
function prepare {}
function build {
    Copy-Item -Recurse "$src_dir/*" "$build_dir/"
}

function install {
    Copy-Item -Recurse "$build_dir/*" "$install_dir"
}