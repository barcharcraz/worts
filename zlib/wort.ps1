#
# wort.ps1
#

#Param(
#  [string]$downloadPath = $(Join-Path $(Get-Location) download),
#  [string]$srcPath = $(Join-Path $(Get-Location) source),
#  [string]$installPath = $(Join-Path $(Get-Location) install),
#  [string]$buildpath = $(Join-Path $(Get-Location) build)
#)

Param(
  [string]$base = $(Get-Location)
)

$url = "http://zlib.net/zlib128.zip"
$hash = "126f8676442ffbd97884eb4d6f32afb4"
Get-WortDefaults $base "zlib" "1.2.8"
$download = $(Join-Path $download_dir "zlib128.zip")

function download {
  Invoke-WebRequest $url -OutFile $download
  if((Get-FileHash -Algorithm MD5 $download).Hash -ne $hash) {
    throw "Error: File {0} failed verification" -f $download
  }
}
function extract {
  Expand-Archive -Path $download -DestinationPath $src_dir
  Move-Item "$src_dir/zlib-1.2.8/*" $src_dir
  Remove-Item "$src_dir/zlib-1.2.8"
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