param(
    [string]$base = $(Get-Location)
)

$url = "https://github.com/assimp/assimp/archive/v3.2.zip"
$hash = "sha-256=59558EADC257F1A6CD6F402CAC2A03AB96BEC2B3BAFDBB51BB525ABE2A544E87"

Get-WortDefaults $base "assimp" "3.2"
Wort-CMakeDefault

Wort-AriaDownload
Wort-CMakeVSBuild
Wort-CMakeVSInstall
function prepare {
    Push-Location $build_dir
    cmake -G "Ninja" -DCMAKE_BUILD_TYPE=RelWithDebInfo `
                    -DASSIMP_BUILD_TESTS=False `
                    -DCMAKE_INSTALL_PREFIX="$install_dir" `
                    $src_dir
    Pop-Location
}