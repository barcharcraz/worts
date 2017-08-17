{.experimental.}
import semver
import macros
import ospaths
import pkgopts
import uri
import options
import strutils

type PkgPlatform* = enum
    ppWin32,
    ppLinux,
    ppBsd,
    ppDarwin

type PkgType* = enum
    ptSource, ## source from upstream
    ptBinary, ## binary from upstream
    ptPackage ## unused for now

type PkgArch* = enum
    pax86,
    paamd64,
    paxarmv7

type PkgBuildSystem* = enum
    pbsMeson,
    pbsCmake
    pbsNim,
    pbsNimble,
    pbsPod,
    pbsAutotools,
    pbsGnomeAutotools,
    pbsKdeCmake,
    pbsQmake,
    pbsGNUMake,
    pbsMake,
    pbsNmake,
    pbsDub,
    pbsCargo,
    pbsMsbuild,
    pbsConan,
    pbsB2,
    pbsChocolatey,
    pbsUnknown





type PkgLayout* = object
    pkg_dir*: string
    build_dir*: string
    download_dir*: string
    src_dir*: string

type PkgTarget* = object
    arch*: PkgArch
    platform*: PkgPlatform


## `Pkg` is the main informational data structure
## describing a package
type
    Pkg* = object
        name*: string
        ver*: string
        url*: string
        hash*: string
        arch*: set[PkgArch]
        platform*: set[PkgPlatform]
        license*: string
        rel*: int
        desc*: string
        kind*: PkgType
        build_sys*: PkgBuildSystem
        bldplatforms*: set[PkgPlatform]
        tgtplatforms*: set[PkgPlatform]
        options*: PkgOptions
        tasks*: PkgTasks
    
    PkgTasks* = object
        download*: proc(pkg: PkgInstall)
        extract*: proc(pkg: PkgInstall)
        prepare*: proc(pkg: PkgInstall)
        build*: proc(pkg: PkgInstall)
        install*: proc(pkg: PkgInstall)
        meta*: proc(pkg: PkgInstall)

    PkgInstall* = object
        target*: PkgTarget 
        pkg*: Pkg
        layout*: PkgLayout

macro `.`*(pkg: PkgInstall, field: string): untyped = 
    ## ^ This makes PkgInstall types act like contatinations
    ##   of the Pkg, PkgVer and PkgLayout types
    var subfields = pkg.getType.last
    expectKind(subfields, nnkRecList)
    for elm in subfields:
        var fields = elm.getType.last
        expectKind(fields, nnkRecList)
        var real_field = findChild(fields, eqIdent(it, $field))
        if real_field != nil:
            result = newDotExpr(pkg, elm).newDotExpr real_field
            return

template `.=`*(pkg: PkgInstall, field: string, rval: untyped) =
    `.`(pkg, field) = rval


proc downloaded_filename*(pkg: Pkg): string = 
    var path = parseUri(pkg.url).path
    var exts = path.split(ExtSep)
    if exts[^1] == "meta4":
        exts = exts[0..^2]
    var ext = ""
    if exts[^2] == "tar":
        ext = exts[^2..^1].join($ExtSep)
    else:
        ext = exts[^1]
    result = pkg.name & "-" & pkg.ver & "." & ext


