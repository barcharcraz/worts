param(
    [string]$base = $(Get-Location)
)

$url = "https://github.com/OSGeo/proj.4/archive/4.9.3.zip"
$hash = "D74ED69DECD8FA2FCB1CF3C7BC94B63901E6BE88723D31CCC10A1488BF80FFD3"

Get-WortDefaults $base "proj4" "4.9.3"

Wort-CMakeDefault

function prepare {
    Push-Location $build_dir
    cmake -G Ninja -DCMAKE_BUILD_TYPE=RelWithDebInfo `
                    -DCMAKE_INSTALL_PREFIX="$install_dir" `
                    -DBUILD_LIBPROJ_SHARED=Yes `
                    $src_dir
    Pop-Location
}
function install {
    ninja -C $build_dir install
    Copy-Item -Path $install_dir/bin/proj_4_9.dll -Destination $install_dir/bin/proj.dll
}