Param(
    [string]$base = $(Get-Location)
)

$url = "http://www.codesynthesis.com/download/odb/2.4/libodb-2.4.0.zip"
$hash = "sha-1=c6b0486ed4168668e1691dec34d61bddccafa1dc"

Get-WortDefaults $base "odb" "2.4.0"

Wort-AriaDownload
Wort-DefaultExtract

function prepare{}
function build{}
function install{}