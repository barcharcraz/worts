import nworts
import semver
import sequtils
import os
import strfmt

var pkg* = newSeq[Pkg]()
pkg.add initPkg()
const cmakefile = slurp("CMakeLists.txt")
pkg.back.name = "sqlite3"
pkg.back.license = "Public Domain"
pkg.back.rel = 1
pkg.back.build_sys = pbsCmake
pkg.back.desc = "The Sqlite database library"
pkg.back.ver = "3.19.3"
pkg.back.url = "https://www.sqlite.org/2017/sqlite-amalgamation-3190300.zip"
pkg.back.hash = "130185efe772a7392c5cecb4613156aba12f37b335ef91e171c345e197eabdc1"
pkg.back.extract:
    default_extract pkg
    writeFile(pkg.src_dir / "CMakeLists.txt", cmakefile)

pkg.add pkg[^1]
pkg.back.ver = "3.20.1"
pkg.back.url = "https://www.sqlite.org/2017/sqlite-amalgamation-3200100.zip"
pkg.back.hash = "sha1=e9dc46fc55a512b5d2ef97fd548b7ab4beb2d3e3"