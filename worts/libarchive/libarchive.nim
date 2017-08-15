import nworts, nake, semver, sequtils, strfmt, untar
const cache = slurp("CMakeCache.txt")
var pkg: PkgInstall
pkg.name = "libarchive"
pkg.license = "BSD"
pkg.rel = 1
pkg.options = cmake_genopts(cache)
pkg.desc = "the libarchive library and utilities"
pkg.build_sys = pbsCmake
pkg.ver = "3.3.1"
pkg.url = "https://www.libarchive.org/downloads/libarchive-3.3.1.tar.gz"
pkg.hash = "29CA5BD1624CA5A007AA57E16080262AB4379DBF8797F5C52F7EA74A3B0424E7"
pkg = wort_defaults pkg
download default_download pkg
extract:
    # we use the untar library since we are buildidng bsdtar, so
    # we want an embedded extraction
    var f = newTarFile($$"${pkg.download_dir}/${pkg.name}-${pkg.ver}.tar.gz")
    untar.extract(f, pkg.src_dir)
    for kind, path in walkDir(pkg.src_dir / $$"${pkg.name}-${pkg.ver}"):
        moveFile(path, pkg.src_dir / extractFilename(path))

prepare default_prepare pkg
build default_build pkg
install default_install pkg
meta cmake_meta pkg