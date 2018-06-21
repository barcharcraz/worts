
import tables
import logging
import pkgdb
import pkgtypes
import defaults
import pkginit
import typeinfo
import pkglayout
import os
import pkgexcept
import terminal

import algorithm
import pkgfmt
import strutils
import pkginit
import semver
import sequtils
{.experimental.}
when appType != "lib": import commandeer



template default_options*() =
    option prefix, string, "prefix", "", expandTilde("~/.worts")
    option editopt, bool, "edit", "e", false

template default_commandline*() =
    argument task, string
    option version, string, "ver", "v", "latest"
    option platform, string, "platform", "p", hostOS
    option options, string, "options", "o", ""

template multi_default_commandline*() =
    subcommand list, "list": discard
    argument name, string

    

template allow_standalone*(pkg: Pkg) =
    when isMainModule:
        commandline:
            default_options()
            default_commandline()
        
        var instinfo: PkgInstall
        instinfo.pkg = pkg
        instinfo.layout = layout(pkg, prefix)
        case task
        of "doall":
            pkg.tasks.download(instinfo)
            pkg.tasks.extract(instinfo)
            pkg.tasks.prepare(instinfo)
            if editopt: pkg.tasks.edit(instinfo)
            pkg.tasks.build(instinfo)
            pkg.tasks.install(instinfo)
            pkg.tasks.meta(instinfo)
        of "download": pkg.tasks.download(instinfo)
        of "extract": pkg.tasks.extract(instinfo)
        of "prepare": pkg.tasks.prepare(instinfo)
        of "edit": pkg.tasks.edit(instinfo)
        of "build": pkg.tasks.build(instinfo)
        of "install": pkg.tasks.install(instinfo)
        of "meta": pkg.tasks.meta(instinfo)
        else: discard


template allow_multiple*(db: seq[Pkg]) =
    block:
        when isMainModule:
            commandLine:
                default_options()
                multi_default_commandline()
                default_commandline()
            
            if list:
                print_packages(db)
            var results = db.filter do (pkg: Pkg) -> bool:
                result = parsePlatform(platform) in pkg.platform
                result = result and pkg.name == name
                if version != "latest":
                    result = result and pkg.ver == version
            
            results.sort do (x,y: Pkg) -> int:
                var xparts = split(x.ver, {'.', '-'})
                var yparts = split(y.ver, {'.', '-'})
                for xpart, ypart in zip(xparts, yparts).items():
                    var xf = parseFloat(xpart)
                    var yf = parseFloat(ypart)
                    result = cmp(xf, yf)
                    if result != 0: break
            case results.len()
            of 0: echo "no matching packages"
            of 1:
                var instinfo: PkgInstall
                var pkg = results[0]
                instinfo.pkg = pkg
                instinfo.layout = layout(pkg, prefix)
                createDirs(instinfo.layout)
                echo(repr instinfo)
                case task
                of "all":
                    pkg.tasks.download(instinfo)
                    pkg.tasks.extract(instinfo)
                    pkg.tasks.prepare(instinfo)
                    if editopt: pkg.tasks.edit(instinfo)
                    pkg.tasks.build(instinfo)
                    pkg.tasks.install(instinfo)
                    pkg.tasks.meta(instinfo)
                of "download": pkg.tasks.download(instinfo)
                of "extract": pkg.tasks.extract(instinfo)
                of "prepare": pkg.tasks.prepare(instinfo)
                of "edit": pkg.tasks.edit(instinfo)
                of "build": pkg.tasks.build(instinfo)
                of "install": pkg.tasks.install(instinfo)
                of "meta": pkg.tasks.meta(instinfo)
                else: discard
            else:
                print_packages(results)


template export_package*(pkg_body: untyped) =
    proc nworts_pkg*(): seq[Pkg] {.exportc, inject.} =
        result = @[]
        result.add(pkg_body)
    when appType == "console":
        var packages = nworts_pkg()
        allow_multiple(packages)