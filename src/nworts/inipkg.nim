import parsecfg
import tables
import pkgtypes
import pkginit

proc initPkgFrom(cfg: Config): Pkg =
    result = initPkg()
    var pkgDict = cfg["pkg"]
    