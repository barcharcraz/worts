

param(
    [string]$base = $(Get-Location)
)

$url ="https://cmake.org/files/v3.6/cmake-3.6.1.zip"
$hash = "6d94468051389fcf0495c7a7acf0bfd9147895a8cf3af7b695a1509764d02679"
Get-WortDefaults $base "cmake" "3.6.1"

$download = $(Join-Path $download_dir "cmake-3.6.1.zip")

function download {
    Invoke-WebRequest $url -OutFile $download
    if((Get-FileHash -Algorithm SHA256 $download).Hash -ne $hash) {
        throw "Error: File {0} failed verification" -f $download
    }
}
function extract {
    Expand-Archive -Path $download -DestinationPath $src_dir
    Move-Item "$src_dir/cmake-3.6.1/*" $src_dir
    Remove-Item "$src_dir/cmake-3.6.1"
}
function prepare {
    Push-Location $build_dir
    cmake $build_dir -G Ninja -DCMAKE_BUILD_TYPE=RelWithDebInfo `
                              -DCMAKE_INSTALL_PREFIX="$install_dir" `
                              $src_dir
    Pop-Location
}
function build {
    ninja -C $build_dir
}
function install {
    ninja -C $build_dir install
}