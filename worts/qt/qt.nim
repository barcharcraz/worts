import nworts, os, strfmt, nakelib
const installScript = slurp("installscript.qs")
var base* = initPkg()

base.name = "Qt"
base.desc = "The Qt GUI library and frameworks"
base.rel = 1
base.license = "LGPL"
base.ver = "5.9.1"
base.platform = {}
base.arch = {}
base.kind = ptBinary
base.tasks = PkgTasks()
base.download = default_download


proc get_instdir(pkg: PkgInstall): string =
  case pkg.platform
  of ppLinux:
    result = "gcc"
  of ppWin32:
    result = "msvc2017"
  else:
    raise newException(PlatformUnsupportedException, "")
  case pkg.arch
    of paamd64: result = result & "_64"
    else: raise newException(PlatformUnsupportedException, "")

proc get_qplat(pkg: PkgInstall): string =
  case pkg.platform
  of ppWin32: result = "win64_" & get_instdir(pkg)
  else: result = get_instdir(pkg)


var bin = base
bin.kind = ptBinary
bin.prepare = proc(pkg: PkgInstall) =
  var vernospace = pkg.ver.replace(".", "")
  var processedScript = installScript.replace("@INSTALL_PREFIX@", pkg.build_dir.replace("\\", "\\\\"))
  processedScript = processedScript.replace("@VERSION@", vernospace)
  processedScript = processedScript.replace("@PLATFORM@", get_qplat(pkg))
  writeFile(pkg.src_dir / "installscript.qs", processedScript)
bin.install = proc(pkg: PkgInstall) =
  var instdir = pkg.build_dir / pkg.ver / pkg.get_instdir()
  for kind, path in os.walkDir(instdir):
    var (head, tail) = splitPath(path)
    echo "installing: " & tail
    case kind
    of pcFile: copyFile(path, pkg.pkg_dir / tail)
    of pcDir: copyDir(path, pkg.pkg_dir / tail)
    else: assert(false)

var lbin = bin
lbin.url = $$"""http://download.qt.io/official_releases/qt/${lbin.ver[0..lbin.ver.rfind(".")-1]}/${lbin.ver}/qt-opensource-linux-x64-${lbin.ver}.run.meta4"""
lbin.hash = "sha256=1dc023a2129c5ac7c7bed7ca85cf4c25ff9fa3c83f88d1db202505ac23d4e413"
lbin.platform = {ppLinux}
lbin.arch = {paamd64}
lbin.build = proc(pkg: PkgInstall) =
  shell($$"chmod +x ${pkg.download_dir}/qt-opensource-linux-x64-${lbin.ver}.run")
  shell($$"""${pkg.download_dir}/qt-opensource-linux-x64-${lbin.ver}.run --script ${pkg.src_dir}/installscript.qs --no-force-installations""")


var wbin = bin
wbin.url = $$"""http://download.qt.io/official_releases/qt/${wbin.ver[0..wbin.ver.rfind(".")-1]}/${wbin.ver}/qt-opensource-windows-x86-${wbin.ver}.exe.meta4"""
wbin.hash = "sha256=f380d5659228a923ddce25e42514e1d22dda7e63ba6e4903cc643dadfe9c050b"
wbin.platform = {ppWin32}
wbin.arch = {paamd64, pax86}
wbin.build = proc(pkg: PkgInstall) =
  shell($$"""${pkg.download_dir}/qt-opensource-windows-x86-${wbin.ver}.exe --script ${pkg.src_dir}/installscript.qs --no-force-installations""")

var pkg* {.exportc.} = [lbin, wbin]