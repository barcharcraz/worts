import nworts, os, ospaths
var p = initPkg()
p.name = "WortEnv"
p.license = "GPLv3"
p.ver = "1.0"
p.tasks = PkgTasks()
p.platform = {ppLinux, ppBsd, ppDarwin}
p.env = @{
  "PATH": "/bin",
  "LD_LIBRARY_PATH": "/lib",
  "STOW_DIR": expandTilde("~/.worts/pkg")
}
p.meta = default_meta

var pkg*: seq[Pkg] = @[p]

p.platform = {ppWin32}
p.env = @{
  "PATH": "/bin",
  "LIB": "/lib",
  "STOW_DIR": expandTilde("~/.worts/pkg")
}
pkg.add p
export_package(pkg)