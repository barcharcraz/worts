import nworts, semver, sequtils, strformat, untar, os
const cache = slurp("CMakeCache.txt")
var p = initPkg()
p.name = "libarchive"
p.license = "BSD"
p.rel = 1
p.options = cmake_genopts(cache)
p.desc = "the libarchive library and utilities"
p.build_sys = pbsCmake
p.ver = "3.3.1"
p.url = "https://www.libarchive.org/downloads/libarchive-3.3.1.tar.gz"
p.hash = "sha-256=29CA5BD1624CA5A007AA57E16080262AB4379DBF8797F5C52F7EA74A3B0424E7"
p.download = default_download
p.extract = proc(pkg: PkgInstall) =
    # we use the untar library since we are buildidng bsdtar, so
    # we want an embedded extraction
    var f = newTarFile(fmt"{pkg.download_dir}/{pkg.name}-{pkg.ver}.tar.gz")
    untar.extract(f, pkg.src_dir)
    for kind, path in walkDir(pkg.src_dir / fmt"{pkg.name}-{pkg.ver}"):
        moveFile(path, pkg.src_dir / extractFilename(path))

p.prepare = default_prepare
p.build = default_build
p.install = default_install
p.meta = cmake_meta

var pkg* = @[p]

p.ver = "3.3.2"
p.url = "https://www.libarchive.org/downloads/libarchive-3.3.2.tar.gz"
p.hash = "sha-256=ED2DBD6954792B2C054CCF8EC4B330A54B85904A80CEF477A1C74643DDAFA0CE"

pkg.add p

export_package(pkg)