##init functions for packages

import pkgtypes
import pkgexcept
import strutils
import defaults
import pkglayout


proc initPkgCompilers*(): PkgCompilers =
    result.cc = pccGcc
    result.cxx = pcxGcc
    result.nim = pncNim
    result.d = pdcDmd
    result.linker = plLd
    case hostOS
    of "Linux":
        result.cc = pccGcc
        result.cxx = pcxGcc
    of "windows":
        result.cc = pccMsvc
        result.cxx = pcxMsvc
        result.linker = plLink
    of "macosx", "openbsd", "freebsd", "netbsd":
        result.cc = pccClang
        result.cxx = pcxClang
        result.linker = plLld
    else: discard

proc initTasks*(): PkgTasks =
    result.build = default_build
    result.download = default_download
    result.edit = default_edit
    result.extract = default_extract
    result.install = default_install
    result.meta = default_meta
    result.prepare = default_prepare

proc initPkg*(): Pkg =
    result.ver = "0"
    result.url = ""
    result.hash = ""
    result.platform = {low(PkgPlatform)..high(PkgPlatform)}
    result.arch = {low(PkgArch)..high(PkgArch)}
    result.rel = 1
    result.options = @[]
    result.env = @[]
    result.kind = ptSource
    result.build_sys = pbsUnknown
    result.tasks = initTasks()
proc initPkgInstall*(): PkgInstall =
    var pkg = initPkg()
    result.pkg = pkg

proc initPkgTarget*(): PkgTarget =
    result.compilers = initPkgCompilers()
    case hostOS:
        of "linux": result.platform = ppLinux
        of "windows": result.platform = ppWin32
        else: raise newException(PlatformUnsupportedException, "")
  
    case hostCPU:
        of "amd64": result.arch = paamd64
        else: raise newException(PlatformUnsupportedException, "")

proc parseTargetSpec*(spec: string): PkgTarget =
    var target = spec.split(":")
    result = initPkgTarget()
    for item in target[0..high(target)]:
        if item.startsWith("pa"): result.arch = parseEnum[PkgArch](item)
        if item.startsWith("pp"): result.platform = parseEnum[PkgPlatform](item) 

proc wort_defaults*(p: Pkg): PkgInstall =
    var p = p
    result.pkg = p
    result.layout = layout(p)
    createDirs(result.layout)
    result.target = initPkgTarget()

    when defined(isolated):
        # when isolated is defined we do our best to be self
        # sufficient
        putEnv("PATH", basedir / "wort_tools" / "bin")

proc wort_defaults*(p: PkgInstall): PkgInstall = wort_defaults(p.pkg)