import nworts, os, strutils

var pkg* = @[initPkg()]
pkg.back.name = "spdlog"
pkg.back.desc = "the speedlog logging framework"
pkg.back.ver = "0.13.0"
pkg.back.url = "https://github.com/gabime/spdlog/archive/v0.13.0.tar.gz"
pkg.back.license = "MIT"
pkg.back.build_sys = pbsCmake

pkg.add pkg.back
pkg.back.ver = "0.14.0"
pkg.back.url = "https://github.com/gabime/spdlog/archive/v0.14.0.tar.gz"