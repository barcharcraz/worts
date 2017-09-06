{.experimental.}
import semver
import macros
import ospaths
import uri
import options
import strutils


type PkgOption* = tuple
    name: string
    value: string

type PkgOptions* = seq[PkgOption]

type PkgEnvVar* = tuple
    name: string
    value: string

type PkgEnvVars* = seq[PkgEnvVar]

type PkgPlatform* = enum
    ppWin32,
    ppLinux,
    ppBsd,
    ppDarwin

type PkgType* = enum
    ptSource, ## source from upstream
    ptBinary, ## binary from upstream
    ptPackage ## unused for now, possibly binary from wort

type PkgArch* = enum
    pax86,
    paamd64,
    paxarmv7,
    paarch64

type PkgCCompiler* = enum
    pccPcc,
    pccTcc,
    pccGcc,
    pccClang,
    pccMsvc,
    pccIcc,
    pccIcl,
    pccClangcl

type PkgNimCompiler* = enum
    pncNim

type PkgCXXCompiler* = enum
    pcxGcc,
    pcxClang,
    pcxMsvc,
    pcxIcc,
    pcxIcl,
    pcxClangcl

type PkgDCompiler* = enum
    pdcDmd,
    pdcLdc

type PkgLinker* = enum
    plLink,
    plLd,
    plLld,
    plGold

type PkgBuildSystem* = enum
    pbsMeson,
    pbsCmake
    pbsNim,
    pbsNimble,
    pbsNpm,
    pbsSetupTools,
    pbsPip,
    pbsPod,
    pbsAutotools,
    pbsGnomeAutotools,
    pbsKdeCmake,
    pbsQmake,
    pbsQbs,
    pbsGNUMake,
    pbsMake,
    pbsNmake,
    pbsDub,
    pbsCargo,
    pbsMsbuild,
    pbsConan,
    pbsBuild2,
    pbsBoostBuild,
    pbsChocolatey,
    pbsUnknown


type PkgCompilers* = object
    cc*: PkgCCompiler
    cxx*: PkgCXXCompiler
    nim*: PkgNimCompiler
    d*: PkgDCompiler
    linker*: PkgLinker



type PkgLayout* = object
    pkg_dir*: string ## the directory where package is installed (the prefix)
    build_dir*: string ## the directory for build files
    download_dir*: string ## the directory for downloads
    src_dir*: string ## the directory where source should be extracted


type PkgTarget* = object
    arch*: PkgArch
    platform*: PkgPlatform
    compilers*: PkgCompilers


## `Pkg` is the main informational data structure
## describing a package
type
    Pkg* = object
        name*: string
        ver*: string
        url*: string
        hash*: string
        arch*: set[PkgArch] ## the archetectures for which this package can be built
        platform*: set[PkgPlatform] ## the platforms for which this package can be built
        license*: string
        rel*: int
        desc*: string
        kind*: PkgType ## kind of package, source/binary
        build_sys*: PkgBuildSystem ## build system, used to select default task actions
        options*: PkgOptions ## the options for a package
        env*: PkgEnvVars
        tasks*: PkgTasks ## the tasks for a package, essentially a virtual table
    
    PkgTasks* = object
        download*: proc(pkg: PkgInstall)
        extract*: proc(pkg: PkgInstall)
        prepare*: proc(pkg: PkgInstall)
        edit*: proc(pkg: PkgInstall)
        build*: proc(pkg: PkgInstall)
        install*: proc(pkg: PkgInstall)
        meta*: proc(pkg: PkgInstall)

    PkgInstall* = object
        target*: PkgTarget ## this is the kind of system the package should *run* on
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


