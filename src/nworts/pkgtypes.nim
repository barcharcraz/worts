{.experimental.}
import semver
import macros

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

type PkgVer* = object
    ver*: string
    url*: string
    hash*: string
    arch*: set[PkgArch]
    platform*: set[PkgPlatform]
    #maybe add gpg signature



type PkgLayout* = object
    pkg_dir*: string
    build_dir*: string
    download_dir*: string
    src_dir*: string


type Pkg* = object
    name*: string
    vers*: seq[PkgVer]
    license*: string
    rel*: int
    desc*: string
    types*: set[PkgType]
    build_sys*: PkgBuildSystem
    platforms*: set[PkgPlatform]

type PkgInstall* = object
    pkg*: Pkg
    version*: PkgVer
    layout*: PkgLayout

proc initPkgInstall*(): PkgInstall =
    var pkg: Pkg
    pkg.vers = @[]
    pkg.rel = 1
    pkg.types = {ptSource}
    pkg.build_sys = pbsUnknown
    pkg.platforms = { low(PkgPlatform)..high(PkgPlatform) }
    result.pkg = pkg

proc initPkgVer*(): PkgVer =
    result.arch = {low(PkgArch)..high(PkgArch)}
    result.platform = {low(PkgPlatform)..high(PkgPlatform)}
proc initPkgVer*(ver: string, url: string, hash: string): PkgVer =
    result = initPkgVer()
    result.ver = ver
    result.url = url
    result.hash = hash
proc initPkgVer*(ver, url, hash: string, arch: set[PkgArch], platform: set[PkgPlatform]): PkgVer =
    result.ver = ver
    result.url = url
    result.hash = hash
    result.arch = arch
    result.platform = platform




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