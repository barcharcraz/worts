Param(
    [string]$base = $(Get-Location)
)

$url = "http://www.codesynthesis.com/download/odb/2.4/libodb-sqlite-2.4.0.zip"
$hash = "sha-1=c95ab4d9f4c7e2828ab2786d9f29e6c55d52f77d"

Get-WortDefaults $base "libodb-sqlite" "2.4.0"

Wort-AriaDownload
Wort-DefaultExtract

function prepare{}
function build{
    $old_inc = $env:INCLUDE
    $old_lib = $env:LIB
    $env:INCLUDE += ";$base\install\include/"
    $env:LIB += ";$base\install\lib"
    devenv "$src_dir/libodb-sqlite-vc12.sln" /upgrade
    msbuild "$src_dir/libodb-sqlite-vc12.sln" /p:Configuration=Release /p:useenv=true
    $env:LIB ="$old_lib"
    $env:INCLUDE ="$old_include"
}
function install{
    New-Item -Force -ItemType Directory -Path "$install_dir/bin"
    New-Item -Force -ItemType Directory -Path "$install_dir/lib"
    New-Item -Force -ItemType Directory -Path "$install_dir/include"
    New-Item -Force -ItemType Directory -Path "$install_dir/include/odb"
    Get-ChildItem "$src_dir/bin64/*" | Rename-Item -NewName {$_.name -replace 'vc12', 'vc14'}
    Copy-Item -Path "$src_dir/bin64/*" -Destination "$install_dir/bin/"
    Copy-Item -Path "$src_dir/lib64/*" -Destination "$install_dir/lib/"

    Copy-Item -Path "$src_dir/odb/*" -Recurse -Destination "$install_dir/include"
    Remove-Item -Path "$install_dir/include/odb/*.vcxproj"
    Remove-Item -Path "$install_dir/include/odb/*.vcproj"
    Remove-Item -Path "$install_dir/include/odb/x64" -Recurse
    Remove-Item -Path "$install_dir/include/odb/Makefile*"
}