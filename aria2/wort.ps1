Param(
    [hashtable]$versions = $versions
)

$pkg_name = "aria2"
$pkg_ver = "1.32.0"
Get-WortDefaults $base
. $versions.$pkg_ver
Wort-DefaultInitialize

Wort-DefaultDownload
WOrt-DefaultExtract

function prepare {}

function latest_version {
    Get-GitHubVersion "aria2/aria2"
}