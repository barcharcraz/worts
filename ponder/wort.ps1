Param(
    [string]$base = $(Get-Location)
)

#$url = "https://github.com/billyquith/ponder/archive/1.3.0.zip"
#$hash = "E713165F9856DA972148C6957AFF8D2CF66E58C4B2D9F45CF41C919236B0B5D6"
$git = "https://github.com/billyquith/ponder.git"

Get-WortDefaults $base "ponder" "master"
#$download = $(Join-Path $download_dir "ponder-1.3.0.zip")

#function download {
#    Invoke-WebRequest $url -OutFile $download
#    if((Get-FileHash -Algorithm SHA256 $download).Hash -ne $hash) {
#        throw "Error: File {0} failed verification" -f $download
#    }
#}
function download {}

#
#function extract {
#    Expand-Archive -Path $download -DestinationPath $src_dir
#    Move-Item "$src_dir/ponder-1.3.0/*" $src_dir
#    Remove-Item "$src_dir/ponder-1.3.0"
#}

function extract {
    git clone -b 1.4 $git $src_dir
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