import nworts, semver, sequtils, strfmt

var pkg* = initPkg()
pkg.name = "fmt"
pkg.rel = 1

pkg.desc = "the fmt formatting library"
pkg.build_sys = pbsCmake
pkg.ver = "4.0.0"
pkg.hash = "35300A0D356529447A79ED5CCF419239D8B34F916E5D4625F046FD37AFA3650A"
pkg.url = "https://github.com/fmtlib/fmt/releases/download/4.0.0/fmt-4.0.0.zip"
pkg.download = default_download
pkg.extract = default_extract
pkg.prepare = default_prepare
pkg.build = default_build
pkg.install = default_install
pkg.meta = cmake_meta