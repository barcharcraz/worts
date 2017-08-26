import nworts, sequtils, os, strfmt

var pkg* = initPkg()
pkg.name = "libtiff"
pkg.license = "BSD"
pkg.desc = "The tiff library and utilities"
pkg.build_sys = pbsCmake
pkg.ver = "4.0.8"
pkg.url = "ftp://download.osgeo.org/libtiff/tiff-4.0.8.tar.gz"
