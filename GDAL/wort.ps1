param(
    [string]$base = $(Get-Location)
)

$url = "http://download.osgeo.org/gdal/2.1.1/gdal211.zip"
$hash = "59C6E3CCB53DD656FBE6B94B4B47205689918D5065F70AED9BA33B73B148ED57"

Get-WortDefaults $base "gdal" "2.1.1"

Wort-DefaultDownload
Wort-DefaultExtract

function prepare {}
function build {
    Push-Location $src_dir
    nmake /f makefile.vc GDAL_HOME=$install_dir MSVC_VER=1900 WIN64=Yes
    Pop-Location
}
function install {
    Push-Location $src_dir
    nmake /f makefile.vc GDAL_HOME=$install_dir MSVC_VER=1900 WIN64=Yes install
    Pop-Location
}