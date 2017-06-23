. "$(Split-Path -parent $PSCommandPath)/wort.source.ps1"

function prepare {
    Push-Location $build_dir
    & $src_dir/configure -prefix "$install_dir"
    Pop-Location
}
function build {
    Push-Location $build_dir
    make -j4
    Pop-Location
}

function install {
    Push-Location $build_dir
    make install
    Pop-Location
}