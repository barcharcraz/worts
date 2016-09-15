
Param(
    [string]$base = $(Get-Location)
)
$url = "http://bitbucket.org/eigen/eigen/get/3.2.9.zip"
$hash = "C6D5620D0D89EE2CECE962AF86713B3455D577C32ABA1F1443E3EE4C43C91143"

Get-WortDefaults $base "eigen" "3.2.9"
$download = $(Join-Path $download_dir "eigen-3.2.8.zip")

function download {
  Invoke-WebRequest $url -OutFile $download
  if((Get-FileHash -Algorithm SHA256 $download).Hash -ne $hash) {
    throw "Error: File {0} failed verification" -f $download
  }
}
function extract {
  Expand-Archive -Path $download -DestinationPath $src_dir
  Move-Item "$src_dir/eigen-eigen-*/*" $src_dir
  Remove-Item "$src_dir/eigen-eigen-*"
}

function prepare {
    Push-Location $build_dir
    cmake -G Ninja -DCMAKE_BUILD_TYPE=RelWithDebInfo `
                    -DCMAKE_INSTALL_PREFIX="$install_dir" `
                    -DCMAKE_PREFIX_PATH="$install_dir" `
                    $src_dir
    Pop-Location
}

function build {
  ninja -C $build_dir
}

function install {
  ninja -C $build_dir install
}