import nworts, os, strfmt, nakelib
const installScript = slurp("installscript.qs")
var base* = initPkg()

base.name = "Qt"
base.desc = "The Qt GUI library and frameworks"
base.rel = 1
base.ver = "5.9.1"
base.platform = {}
base.arch = {}

base.download = default_download




var bin = base
bin.prepare = proc(pkg: PkgInstall) =
  var vernospace = pkg.ver.replace(".", "")
  var processedScript = installScript.replace("@INSTALL_PREFIX@", pkg.build_dir)
  processedScript = processedScript.replace("@VERSION@", vernospace)

  var qplat = ""
  case pkg.platform
  of ppLinux:
    qplat = "gcc"
    case pkg.arch
    of paamd64: qplat &= "_64"
    else: raise newException(PlatformUnsupportedException, "")
  else:
    raise newException(PlatformUnsupportedException, "")
  
  processedScript = processedScript.replace("@PLATFORM@", qplat)
  writeFile(pkg.src_dir / "installscript.qs", processedScript)


var lbin = bin
lbin.url = $$"""http://download.qt.io/official_releases/qt/${lbin.ver[0..lbin.ver.rfind(".")-1]}/${lbin.ver}/qt-opensource-linux-x64-${lbin.ver}.run.meta4"""
lbin.hash = "sha256=1dc023a2129c5ac7c7bed7ca85cf4c25ff9fa3c83f88d1db202505ac23d4e413"
lbin.platform = {ppLinux}
lbin.arch = {paamd64}
lbin.build = proc(pkg: PkgInstall) =
  shell($$"chmod +x ${pkg.download_dir}/qt-opensource-linux-x64-${lbin.ver}.run")
  shell($$"""${pkg.download_dir}/qt-opensource-linux-x64-${lbin.ver}.run --script ${pkg.src_dir}/installscript.qs""")
lbin.install = proc(pkg: PkgInstall) =
  var instdir = pkg.build_dir / pkg.ver / "gcc_64"
  for kind, path in os.walkDir(instdir):
    var (head, tail) = splitPath(path)
    echo "installing: " & tail
    case kind
    of pcFile: copyFile(path, pkg.pkg_dir / tail)
    of pcDir: copyDir(path, pkg.pkg_dir / tail)
    else: assert(false)

proc pkg*(): seq[Pkg] = @[lbin]