## Implements the package database

import pkgtypes
import algorithm
import semver
import options
import macros
import sequtils
import os
import pkginit
import strutils
import pkgfmt
import future

var default_db*: seq[Pkg] = @[]

proc print_packages*(db: seq[Pkg]) =
    var db = db.sorted do (x, y: auto) -> int:
        return cmp(x.name, y.name)
    for pkg in db:
        echo format(pkg)


proc filter*(db: seq[Pkg], version: string, platform: Option[PkgPlatform]): seq[Pkg] =
    var plat = hostPackagePlatform()
    if isSome(platform): plat = platform.get()
    



