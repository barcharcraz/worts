

$versions = @{
    "1.32.0" = {
        $url = "https://github.com/aria2/aria2/releases/download/release-1.32.0/aria2-1.32.0.tar.xz"
        $hash = "546e9194a9135d665fce572cb93c88f30fb5601d113bfa19951107ced682dc50"
    }
}
$pkg_varient = "source"
. "$(Split-Path -parent $PSCommandPath)/wort.ps1"

