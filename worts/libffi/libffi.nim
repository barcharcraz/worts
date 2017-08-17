import nake, nworts, sequtils, os
var pkg* = initPkgInstall()
const cmakefile = slurp("CMakeLists.txt")
pkg.name = "libffi"
pkg.license = "MIT"
pkg.desc = "A library for calling foreign code"
pkg.ver = "3.2.1"
pkg.url = "ftp://sourceware.org/pub/libffi/libffi-3.2.1.tar.gz"
pkg.hash = "sha265=d06ebb8e1d9a22d19e38d63fdb83954253f39bedc5d46232a05645685722ca37"
pkg.download = default_download
pkg.extract = proc(pkg: PkgInstall) =
  default_extract pkg
  writeFile(pkg.src_dir / "CMakeLists.txt", cmakefile)
pkg.build = default_build
pkg.install = default_install
pkg.meta = cmake_meta
