##init functions for packages

import pkgtypes
import pkgexcept
import strutils
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

proc initPkgTarget*(): PkgTarget =
    case hostOS:
        of "linux": result.platform = ppLinux
        of "windows": result.platform = ppWin32
        else: raise newException(PlatformUnsupportedException, "")
  
    case hostCPU:
        of "amd64": result.arch = paamd64
        else: raise newException(PlatformUnsupportedException, "")

proc parseTargetSpec*(spec: string): PkgTarget =
    var target = spec.split(":")
    var arch: PkgArch
    var plat: PkgPlatform
    for item in target[0..high(target)]:
        if item.startsWith("pa"): arch = parseEnum[PkgArch](item)
        if item.startsWith("pp"): plat = parseEnum[PkgPlatform](item) 
    result = PkgTarget(arch: arch, platform: plat)

proc wort_defaults*(p: Pkg): PkgInstall =
    var p = p
    result.pkg = p
    result.layout = layout(p, p.ver)
    createDirs(result.layout)
    result.target = initPkgTarget()

    when defined(isolated):
        # when isolated is defined we do our best to be self
        # sufficient
        putEnv("PATH", basedir / "wort_tools" / "bin")

proc wort_defaults*(p: PkgInstall): PkgInstall = wort_defaults(p.pkg)