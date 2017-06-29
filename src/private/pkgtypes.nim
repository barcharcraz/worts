{.experimental.}
import semver
import macros
type PkgVer* = object
    ver*: Version
    url*: string
    hash*: string
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

type PkgInstall* = object
    pkg*: Pkg
    version*: PkgVer
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