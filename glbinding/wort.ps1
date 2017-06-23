param(
    [string]$base = $base
)
$versions = @{
    "2.1.3" = {
        $url = "https://github.com/cginternals/glbinding/archive/v2.1.3.zip"
        $hash = "de50a56e7e9d98ba8b62383cbffa7954faffeabee6cccf4ad510965ccd475741"
    }
    "2.1.1" = {
        $url = "https://github.com/cginternals/glbinding/archive/v2.1.1.zip"
        $hash = "9F306A7C343BDA4C3204D8A06D59A40A30507D17B12B1592AE5258A6DE696912"
    }
}

$pkg_name = "glbinding"
$pkg_ver = "2.1.3"
$pkg_varient = "source"
Get-WortDefaults $base
. $versions.$pkg_ver

Wort-CMakeDefault

function latest_version {
    Get-GithubVersion 'cginternals/glbinding'
}