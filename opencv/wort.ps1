param(
    [string]$base = $(Get-Location)
)
$url = "https://github.com/opencv/opencv/archive/3.1.0.zip"
$hash = "1F6990249FDB82804FFF40E96FA6D99949023AB0E3277EAE4BD459B374E622A4"
Get-WortDefaults $base "opencv" "3.1.0"

$download = $(Join-Path $download_dir "opencv-3.1.0.zip")

function download {
    Invoke-WebRequest $url -OutFile $download
    if((Get-FileHash -Algorithm SHA256 $download).Hash -ne $hash) {
        throw "Error: File {0} failed verification" -f $download
    }
}
function extract {
    Expand-Archive -Path $download -DestinationPath $src_dir
    Move-Item "$src_dir/opencv-3.1.0/*" "$src_dir"
    Remove-Item "$src_dir/opencv-3.1.0"
}
function prepare {
    Push-Location $build_dir
    cmake -G Ninja -DCMAKE_BUILD_TYPE=RelWithDebInfo `
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