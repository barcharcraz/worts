import nworts, os, strfmt, strutils
var p = initPkg()
p.name = "gflags"
p.desc = "Google Flags"
p.license = "BSD"
p.build_sys = pbsCmake
p.ver = "2.2.1"
p.url = "https://github.com/gflags/gflags/archive/v2.2.1.tar.gz"

export_package(p)