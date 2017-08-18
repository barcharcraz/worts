import nworts, os, strfmt, nakelib

var base = initPkg()
base.build_sys = pbsBoostBuild
base.name = "boost-build"
base.desc = "Boost buildsystem"
base.ver = "2014.10"
base.url = "https://github.com/boostorg/build/releases/download/2014.10/boost-build-2014-10.tar.bz2"
base.tasks = PkgTasks()
base.download = default_download
base.extract = default_extract
base.platform = {}

base.install = proc(pkg: PkgInstall) =
  withDir(pkg.src_dir):
    shell($$"""./b2 install --prefix="${pkg.pkg_dir}" """)

var lpkg = base
lpkg.platform = {ppLinux, ppBsd, ppDarwin}
lpkg.prepare = proc(pkg: PkgInstall) =
  withDir(pkg.src_dir):
    shell("./bootstrap.sh")

var wpkg = base
wpkg.platform = {ppWin32}
wpkg.prepare = proc(pkg: PkgInstall) =
  withDir(pkg.src_dir):
    shell("./bootstrap.bat")


proc pkg*(): auto = @[lpkg, wpkg]