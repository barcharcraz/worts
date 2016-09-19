Param(
    [string]$base = $(Get-Location)
)

$url = "http://www.codesynthesis.com/download/odb/2.4/libodb-2.4.0.zip"
$hash = "sha-1=c6b0486ed4168668e1691dec34d61bddccafa1dc"

Get-WortDefaults $base "libodb" "2.4.0"

Wort-AriaDownload
Wort-DefaultExtract

function prepare{}
function build{
    devenv "$src_dir/libodb-vc12.sln" /upgrade
    msbuild "$src_dir/libodb-vc12.sln" /p:Configuration=Release
}
function install{
    New-Item -Force -ItemType Directory -Path "$install_dir/bin"
    New-Item -Force -ItemType Directory -Path "$install_dir/lib"
    New-Item -Force -ItemType Directory -Path "$install_dir/include"
    Get-ChildItem "$src_dir/bin64/*" | Rename-Item -NewName {$_.name -replace 'vc12', 'vc14'}
    Copy-Item -Path "$src_dir/bin64/*" -Destination "$install_dir/bin/"
    Copy-Item -Path "$src_dir/lib64/*" -Destination "$install_dir/lib/"
    Copy-Item -Path "$src_dir/odb" -Recurse -Destination "$install_dir/include"
    Remove-Item -Path "$install_dir/include/odb/*.vcxproj"
    Remove-Item -Path "$install_dir/include/odb/*.vcproj"
    Remove-Item -Path "$install_dir/include/odb/x64" -Recurse
    Remove-Item -Path "$install_dir/include/odb/Makefile*"
}