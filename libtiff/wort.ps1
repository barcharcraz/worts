param(
    [string]$base = $(Get-Location)
)
$hash = "sha-256=B0447585C647DF0404472811042DF02360A958E9AFB806C73D44FE2F163885A2"
$url = "http://download.osgeo.org/libtiff/tiff-4.0.6.zip"


Get-WortDefaults $base "libtiff" "4.0.6"

Wort-CMakeDefault
Wort-AriaDownload