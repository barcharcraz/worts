
Param(
    [string]$base = $(Get-Location)
)

$url = "https://github.com/SOCI/soci/archive/3.2.3.zip"
$hash = "10D4A66218780F2EA85E5B9454E478E2C45370F7264B5B03957BA1ABAF9CD451"

Get-WortDefaults $base "SOCI" "3.2.3"
Wort-CMakeDefault

function prepare {
    Push-Location $build_dir
    cmake -G Ninja -DCMAKE_BUILD_TYPE=RelWithDebInfo `
                    -DCMAKE_INSTALL_PREFIX="$install_dir" `
                    -DLIBDIR="$install_dir/lib" `
                    "$src_dir/src"
    Pop-Location
}