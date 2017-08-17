##init functions for packages

import pkgtypes
import defaults

proc initTasks*(): PkgTasks =
    result.build = default_build
    result.download = default_download
    result.extract = default_extract
    result.install = default_install
    result.meta = default_meta
    result.prepare = default_prepare

proc initPkg*(): Pkg =
    result.ver = "0"
    result.url = ""
    result.hash = ""
    result.arch = {low(PkgArch)..high(PkgArch)}
    result.rel = 1
    result.options = @[]
    result.kind = ptSource
    result.build_sys = pbsUnknown
    result.bldplatforms = { low(PkgPlatform)..high(PkgPlatform) }
    result.tgtplatforms = { low(PkgPlatform)..high(PkgPlatform) }
    result.tasks = initTasks()
proc initPkgInstall*(): PkgInstall =
    var pkg = initPkg()
    result.pkg = pkg