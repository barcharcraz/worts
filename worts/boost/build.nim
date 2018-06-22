import nworts, os
import strformat

var bases = @[initPkg()]
bases.back.build_sys = pbsBoostBuild
bases.back.name = "boost-build"
bases.back.desc = "Boost buildsystem"
bases.back.ver = "1.65.0"
bases.back.url = "https://github.com/boostorg/build/archive/boost-1.65.0.zip"
bases.back.tasks = PkgTasks()
bases.back.download = default_download
bases.back.extract = default_extract
bases.back.platform = {}

bases.add bases.back
bases.back.ver = "1.67.0"
bases.back.url = "https://github.com/boostorg/build/archive/boost-1.67.0.zip"
var pkg = newSeq[Pkg]()
for base in bases:
  var lpkg = base
  lpkg.platform = {ppLinux, ppBsd, ppDarwin}
  lpkg.prepare = proc(pkg: PkgInstall) =
    withDir(pkg.src_dir):
      shell("./bootstrap.sh")
  lpkg.install = proc(pkg: PkgInstall) =
    withDir(pkg.src_dir):
      shell(fmt"""./b2 install --prefix="{pkg.pkg_dir}" """)

  var wpkg = base
  wpkg.platform = {ppWin32}
  wpkg.prepare = proc(pkg: PkgInstall) =
    withDir(pkg.src_dir):
      shell("bootstrap.bat")
  wpkg.install = proc(pkg: PkgInstall) =
    withDir(pkg.src_dir):
      shell(fmt"""b2 install --prefix="{pkg.pkg_dir}" """)

  pkg.add [lpkg, wpkg]

export_package(pkg)