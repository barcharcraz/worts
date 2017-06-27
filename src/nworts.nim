{.experimental.}
import os
import strfmt
import nakelib
import semver
import tables
import hashes
import macros
import algorithm

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

type PkgInstall = object
    pkg: Pkg
    version: PkgVer
    layout: PkgLayout



var basedir = expandTilde("~/.worts")

proc hash*(v: Version): Hash = hash($v)

proc layout*(pkg: Pkg, ver: string): PkgLayout =
    var pkgdir = basedir / "pkg"
    var blddir = basedir / "bld"
    var pkgid = $$"${pkg.name}-${ver}-${pkg.rel}"
    result.pkg_dir = pkgdir / pkgid
    result.build_dir = blddir / pkgid / "build"
    result.src_dir = blddir / pkgid / "source"
    result.download_dir = basedir / "downloads"

proc createDirs*(layout: PkgLayout) = 
    createDir layout.build_dir
    createDir layout.pkg_dir
    createDir layout.download_dir
    createDir layout.src_dir

proc deleteDirs*(layout: PkgLayout) = 
    removeDir layout.build_dir
    removeDir layout.pkg_dir
    removeDir layout.download_dir
    removeDir layout.src_dir

proc wort_defaults*(p: Pkg): PkgInstall =
    var p = p
    p.vers.sort() do (x: auto, y: auto) -> int: cmp(x.ver, y.ver)
    result.version = p.vers[0]
    result.pkg = p
    result.layout = layout(p, $p.vers[0].ver)


#proc default_extract()


template download*(body: untyped) = task("download", "download package sources or binaries from upstream", body)
template extract*(body: untyped) = task("extract", "extract package sources or binaries", body)
template prepare*(body: untyped) = task("prepare", "prepare or configure package for building", body)
template build*(body: untyped) = task("build", "build the package", body)
template install*(body: untyped) = task("install", "Install the package to it's pkg folder", body)
