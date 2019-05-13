using module ..\worts.psd1
Set-StrictMode  -Version Latest

function test {

}

class ZlibPackage {
    $name = "zlib"
    [semver]$version = "1.2.11"
    $url = "https://www.zlib.net/zlib-1.2.11.tar.gz"
}
$t = [ZlibPackage]::new()
