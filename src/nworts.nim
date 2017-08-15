{.experimental.}
import os
import strfmt
import nakelib
import tables
import hashes
import typeinfo
import macros
import algorithm
import nworts.pkgtypes
import nworts.defaults
import nworts.pkgtasks
import nworts.pkgopts
export pkgtypes
export defaults
export pkgtasks
export pkgopts

    



proc layout*(pkg: Pkg, ver: string): PkgLayout =
    when defined(packager):
        result.pkg_dir = basedir / "pkg"
        result.build_dir = basedir / "build"
        result.src_dir = basedir / "source"
        result.download_dir = basedir
    else:
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
    result.pkg = p
    result.layout = layout(p, p.ver)
    createDirs(result.layout)
    when defined(isolated):
        # when isolated is defined we do our best to be self
        # sufficient
        putEnv("PATH", basedir / "wort_tools" / "bin")

proc wort_defaults*(p: PkgInstall): PkgInstall = wort_defaults(p.pkg)

#proc default_extract()



