import nake
import nworts
import semver
var pkg: Pkg
pkg.name = "sqlite3"
pkg.license = "Public Domain"
pkg.rel = 1
pkg.desc = "The Sqlite database library"
pkg.vers = {
    "3.19.3": PkgVer(
        url: "https://www.sqlite.org/2017/sqlite-amalgamation-3190300.zip",
        hash: "130185efe772a7392c5cecb4613156aba12f37b335ef91e171c345e197eabdc1"
    )
}.toOrderedTable
