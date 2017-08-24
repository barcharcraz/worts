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


proc filter*(db: seq[Pkg], flt: string): seq[Pkg] =
    result = db.filter do (item: Pkg) -> bool:
        var splitstr = flt.split(":")
        var v = v"0.0.0"
        for elm in splitstr:
            if elm[0] == 'v':
                v = parseVersion(elm[1..^1])
        var tgtspec = join(splitstr[1..high(splitstr)], ":")
        
        var target = parseTargetSpec(tgtspec)

        result = item.name == splitstr[0]
        if v != v"0.0.0": result = result and parseVersion(item.ver) == v
        result = result and target.platform in item.platform
        result = result and target.arch in item.arch


