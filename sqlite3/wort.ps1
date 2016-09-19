param(
    [string]$base = $(Get-Location)
)

$url = "https://www.sqlite.org/2016/sqlite-amalgamation-3140000.zip"
$hash = "27a518342e0609455cfe39b4188f6107914ca9cd"
$cmake_file = "https://raw.githubusercontent.com/snikulov/sqlite.cmake.build/master/CMakeLists.txt"
Get-WortDefaults $base "sqlite" "3.14.0"

$download = $(Join-Path $download_dir "sqlite-amalgamation-3140000.zip")

function download {
    Invoke-WebRequest $url -OutFile $download
    if((Get-FileHash -Algorithm SHA1 $download).Hash -ne $hash) {
        throw "Error: File {0} failed verification" -f $download
    }
}
function extract {
    Expand-Archive -Path $download -DestinationPath $src_dir
    New-Item -ItemType Directory "$src_dir/src"
    Move-Item "$src_dir/sqlite-amalgamation-3140000/*" $src_dir/src
    Remove-Item "$src_dir/sqlite-amalgamation-3140000"
    Invoke-WebRequest $cmake_file -OutFile "$src_dir/CMakeLists.txt"
}
function prepare {
    Push-Location $build_dir
    cmake -G Ninja -DCMAKE_BUILD_TYPE=RelWithDebInfo `
                   -DCMAKE_INSTALL_PREFIX="$install_dir" `
                   -DWITH_SQLITE_RTREE=ON `
                   -DWITH_SQLITE_UNLOCK_NOTIFY=ON `
                   $src_dir
    Pop-Location
}
function build {
    ninja -C $build_dir
}
function install {
    ninja -C $build_dir install
}