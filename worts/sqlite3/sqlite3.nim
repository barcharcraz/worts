import nake
import nworts
import semver
import sequtils
import os
import strfmt
var pkg: Pkg
const cmakefile = slurp("CMakeLists.txt")
pkg.name = "sqlite3"
pkg.license = "Public Domain"
pkg.rel = 1
pkg.desc = "The Sqlite database library"
pkg.vers = @[
    initPkgVer(
        ver = "3.19.3",
        url = "https://www.sqlite.org/2017/sqlite-amalgamation-3190300.zip",
        hash = "130185efe772a7392c5cecb4613156aba12f37b335ef91e171c345e197eabdc1"
    )
]
var info = wort_defaults(pkg)

download default_download info
extract:
    default_extract info
    writeFile(info.src_dir / "CMakeLists.txt", cmakefile)

prepare default_prepare info

build default_build info
    
install default_install info
    