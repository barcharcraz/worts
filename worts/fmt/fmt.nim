import nworts, semver, sequtils, strformat

var pkg* = initPkg()
pkg.name = "fmt"
pkg.rel = 1
pkg.desc = "the fmt formatting library"
pkg.build_sys = pbsCmake
pkg.ver = "4.0.0"
pkg.hash = "sha-256=10a9f184d4d66f135093a08396d3b0a0ebe8d97b79f8b3ddb8559f75fe4fcbc3"
pkg.url = "https://github.com/fmtlib/fmt/releases/download/4.0.0/fmt-4.0.0.zip"

export_package(pkg)