Param(
    [string]$base = $(Get-Location)
)


$url = "http://download.osgeo.org/geos/geos-3.5.0.tar.bz2"
#$hash = "sha-256=49982B23BCFA64A53333DAB136B82E25354EDEB806E5A2E2F5B8AA98B1D0AE02"


Get-WortDefaults $base "geos" "trunk"
function download {
    svn checkout http://svn.osgeo.org/geos/trunk $src_dir
}
function extract {}
'
function extract {
    cmd /C "7z x $download -so | 7z x -aoa -si -ttar -o$build_dir"
    $children = Get-ChildItem $src_dir
    Write-Output $children
    if($children.Length -eq 1) {
        Write-Output "Moving Files from single subdirectory"
        $dirname = $children[0].Name
        Write-Output "$src_dir/$dirname/*"
        Move-Item "$src_dir/$dirname/*" $src_dir
        Remove-Item $children[0].FullName
    }
}
'
Wort-CMakeDefaultPrepare

Wort-CMakeDefaultBuild

Wort-CMakeDefaultInstall