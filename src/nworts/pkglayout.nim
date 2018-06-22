import pkgtypes
import ospaths
import os
import strformat
when defined(packager):
    var basedir* = getCurrentDir()
else:
    var basedir* = expandTilde("~/.worts")


proc layout*(pkg: Pkg, prefix: string = basedir): PkgLayout =
    var pkgdir = basedir / "pkg"
    var blddir = basedir / "bld"
    var pkgid = fmt"{pkg.name}-{pkg.ver}-{pkg.rel}"
    result.pkg_dir = pkgdir / pkgid
    result.build_dir = blddir / pkgid / "build"
    result.src_dir = blddir / pkgid / "source"
    result.download_dir = basedir / "downloads"
    result.meta_dir = result.pkg_dir / fmt"share/worts/{pkg.name}"


proc createDirs*(layout: PkgLayout) = 
    createDir layout.build_dir
    createDir layout.pkg_dir
    createDir layout.download_dir
    createDir layout.src_dir
    createDir layout.meta_dir

proc deleteDirs*(layout: PkgLayout) = 
    removeDir layout.build_dir
    removeDir layout.pkg_dir
    removeDir layout.download_dir
    removeDir layout.src_dir