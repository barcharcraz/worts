import nworts, os, strutils

var pkg* = initPkg()
pkg.name = "spdlog"
pkg.desc = "the speedlog logging framework"
pkg.ver = "0.13.0"
pkg.url = "https://github.com/gabime/spdlog/archive/v0.13.0.tar.gz"
pkg.license = "MIT"
pkg.build_sys = pbsCmake