{.experimental.}
import os
import strfmt
import nakelib
import semver
import tables
import hashes
import typeinfo
import macros
import algorithm
import private.pkgtypes
import private.defaults
import private.pkgtasks
export pkgtypes
export defaults
export pkgtasks

    

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
    createDirs(result.layout)


#proc default_extract()



