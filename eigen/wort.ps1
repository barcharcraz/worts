
Param(
    [string]$base = $(Get-Location)
)
$versions = @{
  "3.3.4" = {
    $url = "http://bitbucket.org/eigen/eigen/get/3.3.4.tar.bz2"
    $hash = "dd254beb0bafc695d0f62ae1a222ff85b52dbaa3a16f76e781dce22d0d20a4a6"
  }
  "3.2.9" = {
      $url = "http://bitbucket.org/eigen/eigen/get/3.2.9.zip"
      $hash = "C6D5620D0D89EE2CECE962AF86713B3455D577C32ABA1F1443E3EE4C43C91143"
  }
}
$pkg_ver = "3.3.4"
. $versions.$pkg_ver
Get-WortDefaults $base "eigen" "3.3.4"

Wort-CmakeDefault