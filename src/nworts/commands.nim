
import tables
import logging
import pkgdb
import pkgtypes
import defaults
import typeinfo
import os
import pkgexcept
import terminal
import algorithm
import pkgfmt
import strutils
import pkginit
import semver
import sequtils

proc exec*(pkg: Pkg, taskname: string, target: PkgTarget) =
    var installInfo = wort_defaults pkg
    installInfo.target = target
    for name, val in pkg.tasks.fieldPairs():
        if name == taskname: val(installInfo)
        elif taskname == "all" and val != nil:
            styledEcho( fgYellow, "📦", resetStyle, ": executing " & name )
            val(installInfo)


template allow_standalone*(pkg: Pkg) =
    when isMainModule:
        var args = commandLineParams()
        var target = initPkgTarget()
        echo args
        if args.len == 0:
            echo format(pkg)
        else:
            exec(pkg, args[0].string, target)

template allow_multiple*(db: seq[Pkg]) =
    
    when isMainModule:
        var args = commandLineParams()
        echo args
        case args.len
        of 0:
            for pkg in db:
                echo format(pkg)
        of 1:
            for pkg in db.filter(args[0]):
                echo format(pkg)
        of 2..3:
            var matches = db.filter(args[0])
            matches.sort do (a: Pkg, b: Pkg) -> int:
                cmp(parseVersion(a.ver), parseVersion(b.ver))
            if matches.len == 0:
                raise newException(PackageNotFoundException, "")
            if matches.len > 1:
                raise newException(PackageNotUniqueException, "")
            var target = initPkgTarget()
            if args.len == 3: target = parseTargetSpec(args[2])
            exec(matches[0], args[1], target)
        else:
            raise newException(ValueError, "")