import nworts
import semver
import sequtils
import strformat
var pkg = initPkg()
pkg.name = "libiconv"
pkg.license = "GPL/LGPL"
pkg.rel = 1
pkg.desc = "the gnu iconv library"
pkg.ver = "1.15"
pkg.url = "https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.15.tar.gz"
pkg.hash = "ccf536620a45458d26ba83887a983b96827001e92a13847b45e4925cc8913178"

pkg.download = default_download
pkg.extract = default_extract
pkg.prepare = default_prepare
pkg.build = default_build
pkg.install = default_install
pkg.meta = cmake_meta