

import nworts, untar, os, strfmt, nakelib

var pkg*: seq[Pkg] = @[]

const allow_warnings = slurp("allow-warnings-msvc.patch")

var base = initPkg()
base.name = "ninja"
base.ver = "1.7.2"
base.desc = "ninja build system"
base.build_sys = pbsUnknown
base.url = "https://github.com/ninja-build/ninja/archive/v1.7.2.tar.gz"
base.extract = proc(pkg: PkgInstall) =
    # we use the untar library since we are buildidng bsdtar, so
    # we want an embedded extraction
    var f = newTarFile($$"${pkg.download_dir}/${pkg.name}-${pkg.ver}.tar.gz")
    untar.extract(f, pkg.src_dir)
    for kind, path in walkDir(pkg.src_dir / $$"${pkg.name}-${pkg.ver}"):
        moveFile(path, pkg.src_dir / extractFilename(path))
base.prepare = proc(pkg: PkgInstall) =
    withDir pkg.src_dir:
        writeFile("allow-warnings-msvc.patch", allow_warnings)
        shell("git apply allow-warnings-msvc.patch")
base.build = proc(pkg: PkgInstall) =
    withDir pkg.src_dir:
        shell("python configure.py --bootstrap")

base.install = proc(pkg: PkgInstall) =
    withDir(pkg.src_dir):
        createDir(pkg.pkg_dir / "bin")
        copyFile("ninja.exe", pkg.pkg_dir / "bin" / "ninja.exe")

pkg.add base

allow_standalone base