$versions = @{
    "4.0.8" = {
        $hash = "099c77cf0975a79c8425f22884fd2dc1d6ce072119e3f39f751c6f4480533e23"
        $url = "http://download.osgeo.org/libtiff/tiff-4.0.8.zip"
    }
    "4.0.6" = {
        $hash = "B0447585C647DF0404472811042DF02360A958E9AFB806C73D44FE2F163885A2"
        $url = "http://download.osgeo.org/libtiff/tiff-4.0.6.zip"
    }

}

$pkg_name = "libtiff"
$pkg_ver = "4.0.8"
$pkg_varient = "source"
Get-WortDefaults
. $versions.$pkg_ver

Wort-CMakeDefault