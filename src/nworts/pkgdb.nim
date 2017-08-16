## Implements the package database

import pkgtypes
import algorithm
import semver
import options
import macros

macro wrapType(typ: typed, wrapwith: typed): typed =
    dumpTree: getAst(typ)
    dumptree: wrapwith

proc matches(spec: Pkg, candidate: Pkg): bool =
    result = result and (spec.name == candidate.name)
    result = result and (parseVersion(spec.ver) == parseVersion(candidate.ver)


wrapType(Pkg, Option)