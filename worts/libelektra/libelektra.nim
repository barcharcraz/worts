import nworts, semver, sequtils, os, strfmt
var pkg* = initPkg()
pkg.name = "libelektra"
pkg.build_sys = pbsCmake
pkg.license = "BSD"
pkg.ver = "0.8.19"
pkg.url = "https://github.com/ElektraInitiative/libelektra/releases/download/0.8.19/elektra-0.8.19.tar.gz"