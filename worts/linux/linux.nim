import nworts, os, strfmt, strutils

var pkg*: seq[Pkg] = @[]

pkg.add initPkg()
pkg.back.name = "linux"
pkg.back.license = "GPLv2"
pkg.back.build_sys = pbsMake
pkg.back.ver = "4.12.8"
pkg.back.url = "https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.12.8.tar.xz"
pkg.back.platform = {ppLinux}
