import os
import strfmt
import nakelib
import semver
import tables



type PkgVer* = object
    ver: Version
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
    vers*: OrderedTable[Version, PkgVer]
    license*: string
    rel*: int
    desc*: string

var basedir = expandTilde("~/.worts")

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



template download*(body: untyped) = task("download", "download package sources or binaries from upstream", body)
template extract*(body: untyped) = task("extract", "extract package sources or binaries")
template prepare*(body: untyped) = task("prepare", "prepare or configure package for building", body)
template build*(body: untyped) = task("build", "build the package")
template install*(body: untyped) = task("install", "Install the package to it's pkg folder")