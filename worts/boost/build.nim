import nworts, os
import strformat

var base = initPkg()
base.build_sys = pbsBoostBuild
base.name = "boost-build"
base.desc = "Boost buildsystem"
base.ver = "1.65.0"
base.url = "https://github.com/boostorg/build/archive/boost-1.65.0.zip"
base.tasks = PkgTasks()
base.download = default_download
base.extract = default_extract
base.platform = {}



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

var pkg* = [lpkg, wpkg]

export_package(pkg)