import nworts, os, strfmt, strutils
var pkg* = initPkg()
pkg.name = "boost"
pkg.license = "boost"
pkg.desc = "The Boost c++ libraries"
pkg.build_sys = pbsBoostBuild
pkg.ver = "1.64.0"
pkg.url = "https://dl.bintray.com/boostorg/release/1.64.0/source/boost_1_64_0.tar.gz"
