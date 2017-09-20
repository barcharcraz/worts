import nworts, os, strfmt, strutils
var pkg = initPkg()
pkg.name = "gflags"
pkg.desc = "Google Flags"
pkg.license = "BSD"
pkg.build_sys = pbsCmake
pkg.ver = "2.2.1"
pkg.url = "https://github.com/gflags/gflags/archive/v2.2.1.tar.gz"

export_package(pkg)