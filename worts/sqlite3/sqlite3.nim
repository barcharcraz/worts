import nworts
import semver
import sequtils
import os
import strfmt
var pkg* = initPkg()
const cmakefile = slurp("CMakeLists.txt")
pkg.name = "sqlite3"
pkg.license = "Public Domain"
pkg.rel = 1
pkg.build_sys = pbsCmake
pkg.desc = "The Sqlite database library"
pkg.ver = "3.19.3"
pkg.url = "https://www.sqlite.org/2017/sqlite-amalgamation-3190300.zip"
pkg.hash = "130185efe772a7392c5cecb4613156aba12f37b335ef91e171c345e197eabdc1"

pkg.extract = proc(pkg: PkgInstall) =
    default_extract pkg
    writeFile(pkg.src_dir / "CMakeLists.txt", cmakefile)