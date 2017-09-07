import nworts, os, ospaths
var p = initPkg()
p.name = "WortEnv"
p.license = "GPLv3"
p.ver = "1.0"
p.tasks = PkgTasks()
p.env = @{
  "PATH": "/bin",
  "LD_LIBRARY_PATH": "/lib",
  "LIB": "/lib"
}
p.meta = default_meta
