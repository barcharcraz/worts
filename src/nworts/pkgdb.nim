## Implements the package database

import pkgtypes
import algorithm
import semver
import options
import macros
import sequtils
import os
import strutils
import pkgfmt

var default_db*: seq[Pkg] = @[]

proc print_packages*(db: seq[Pkg]) =
    var db = db.sorted do (x, y: auto) -> int:
        return cmp(x.name, y.name)
    for pkg in db:
        echo format(pkg)


proc filter*(db: seq[Pkg], flt: string): seq[Pkg] =
    result = db.filter do (item: Pkg) -> bool: 
        var target = flt.split(":")
        var arch: PkgArch
        var plat: PkgPlatform
        for item in target[1..high(target)]:
            if item.startsWith("pa"): arch = parseEnum[PkgArch](item)
            if item.startsWith("pp"): plat = parseEnum[PkgPlatform](item) 
        result = item.name == target[0]
        if target.len > 1:
            result = result and plat in item.platform
            result = result and arch in item.arch
