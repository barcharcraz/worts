param(
    [string]$base = $(Get-Location)
)

$url = "https://github.com/cginternals/glbinding/archive/v2.1.1.zip"
$hash = "9F306A7C343BDA4C3204D8A06D59A40A30507D17B12B1592AE5258A6DE696912"

Get-WortDefaults $base "glbinding" "2.1.1"

Wort-CMakeDefault