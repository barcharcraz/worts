import nworts, nake, semver, sequtils, strfmt

var pkg = initPkgInstall()
pkg.name = "fmt"
pkg.rel = 1

pkg.desc = "the fmt formatting library"
pkg.build_sys = pbsCmake
pkg.vers = @[
    initPkgVer(
        ver = "4.0.0",
        hash = "35300A0D356529447A79ED5CCF419239D8B34F916E5D4625F046FD37AFA3650A",
        url = "https://github.com/fmtlib/fmt/releases/download/4.0.0/fmt-4.0.0.zip"
    )
]
pkg = wort_defaults pkg
download default_download pkg
extract default_extract pkg
prepare default_prepare pkg
build default_build pkg
install default_install pkg
meta cmake_meta pkg