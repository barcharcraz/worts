
import tables
import logging
import pkgdb
import pkgtypes
import defaults
import typeinfo
import os
import pkgexcept
import algorithm
import pkgfmt
import strutils
import sequtils

proc exec*(pkg: Pkg, taskname: string) =
    var installInfo = wort_defaults pkg
    for name, val in pkg.tasks.fieldPairs():
        if name == taskname: val(installInfo)

template allow_standalone*(pkg: Pkg) =
    when isMainModule:
        var args = commandLineParams()
        echo args
        if args.len == 0:
            echo format(pkg)
        else:
            exec(pkg, args[0])

template allow_multiple*(db: seq[Pkg]) =
    when isMainModule:
        var args = commandLineParams()
        echo args
        if args.len == 0:
            for pkg in db:
                echo format(pkg)
        elif args.len == 1:
            for pkg in db.filter(args[0]):
                echo format(pkg)
        elif args.len == 2:
            var matches = db.filter(args[0])
            if matches.len == 0:
                raise newException(PackageNotFoundException, "")
            if matches.len > 1:
                raise newException(PackageNotUniqueException, "")
            exec(matches[0], args[1])