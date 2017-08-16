## Implements the package database

import pkgtypes
import algorithm
import semver
import options
import macros
import pkgfmt

var default_db*: seq[Pkg] = @[]

proc print_packages*(db: seq[Pkg]) =
    var db = db.sorted do (x, y: auto) -> int:
        return cmp(x.name, y.name)
    for pkg in db:
        echo format(pkg)
