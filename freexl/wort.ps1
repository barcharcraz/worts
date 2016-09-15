Param(
    [string]$base = $(Get-Location)
)

$url = "http://www.gaia-gis.it/gaia-sins/freexl-1.0.2.zip"
$hash = "sha-256=076C2EA1545C933B97777CEA89C4508B071DD6F2A06246E7558F79F582762278"

Get-WortDefaults $base "FreeXL" "1.0.2"
Wort-AriaDownload
Wort-DefaultExtract

function prepare {

}
function build {
    Push-Location $src_dir
    nmake /f makefile.vc INSTDIR=$install_dir
}