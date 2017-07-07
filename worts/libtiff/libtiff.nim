import nworts, sequtils, os, strfmt, nake

var pkg = initPkgInstall()
pkg.name = "libtiff"
pkg.license = "BSD"
pkg.desc = "The tiff library and utilities"
pkg.vers = @[
    initPkgVer(
        ver = "4.0.8",
        url = "ftp://download.osgeo.org/libtiff/tiff-4.0.8.tar.gz",
        hash = ""
    )
]
pkg = wort_defaults pkg
