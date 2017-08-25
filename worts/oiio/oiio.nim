import nworts

var pkg* = newSeq[Pkg]()
const cache = slurp("CMakeCache.txt")
pkg.add initPkg()
pkg.back.name = "OpenImageIO"
pkg.back.desc = "Open Image IO"
pkg.back.license = "BSD"
pkg.back.options = cmake_genopts(cache)
pkg.back.ver = "1.7.16"
pkg.back.url = "https://github.com/OpenImageIO/oiio/archive/Release-1.7.16.tar.gz"
pkg.back.build_sys = pbsCmake