. "$(Split-Path -parent $PSCommandPath)/wort.ps1"

function build {
    New-Item -ItemType Directory "$build_dir/bin"
    Copy-Item -Path "$src_dir/aria2c.exe" -Destination "$build_dir/bin"
}

function install {
    Copy-Item -Recurse "$build_dir/*" "$install_dir"
}