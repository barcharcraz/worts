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
        var tgtspec = join(splitstr[1..high(splitstr)], ":")
        var target = parseTargetSpec(tgtspec)
        result = item.name == splitstr[0]
        result = result and target.platform in item.platform
        result = result and target.arch in item.arch

type pkgFilter = object
    pfx: string ## prefix to trigger the filter, longest match first
                ## must be unique
    cmp: proc(a: Pkg, b: string): bool ## does the filter evaluate as true for a given package

proc initPkgFilter(pfx: string, cmp: (a: Pkg, b: string) -> bool): pkgFilter =
    result.pfx = pfx
    result.cmp = cmp

template filterprefix(pfx: typed, body: untyped) =
    initPkgFilter(pfx) do (a: Pkg, b: string) -> bool:
        result = body

var fltdb = newSeq[pkgFilter]()

fltdb.add filterprefix("pp") do: parseEnum[PkgPlatform](b) in a.platform
fltdb.add initPkgFilter("pa") do (a, b: auto) -> auto: parseEnum[PkgArch](b) in a.arch
