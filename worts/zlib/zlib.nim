import nworts, semver, sequtils, strfmt, untar, os, future

var pkg* = initPkg()
const defaults = slurp("CMakeCache.txt")
pkg.name = "zlib"
pkg.license = "zlib"
pkg.rel = 1
pkg.options = cmake_genopts(defaults)
pkg.desc = "The zlib archival library"
pkg.build_sys = pbsCmake
pkg.ver = "1.2.11"
pkg.url = "https://zlib.net/zlib-1.2.11.tar.gz"
pkg.hash = "sha-256=c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1"

pkg.extract = proc(pkg: PkgInstall) =
    # we use the untar library since we are buildidng bsdtar, so
    # we want an embedded extraction
    var f = newTarFile($$"${pkg.download_dir}/${pkg.name}-${pkg.ver}.tar.gz")
    untar.extract(f, pkg.src_dir)
    for kind, path in walkDir(pkg.src_dir / $$"${pkg.name}-${pkg.ver}"):
        moveFile(path, pkg.src_dir / extractFilename(path))
