import pkgtypes
import ospaths
import os
import strfmt
when defined(packager):
    var basedir* = getCurrentDir()
else:
    var basedir* = expandTilde("~/.worts")


proc layout*(pkg: Pkg): PkgLayout =
    when defined(packager):
        result.pkg_dir = basedir / "pkg"
        result.build_dir = basedir / "build"
        result.src_dir = basedir / "source"
        result.download_dir = basedir
    else:
        var pkgdir = basedir / "pkg"
        var blddir = basedir / "bld"
        var pkgid = $$"${pkg.name}-${pkg.ver}-${pkg.rel}"
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