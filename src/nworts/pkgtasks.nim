import nakelib
import pkgtypes
#template download*(body: untyped) = 
#    task("download", "download package sources or binaries from upstream", body)
#template extract*(body: untyped) = 
#    task("extract", "extract package sources or binaries", body)
#template prepare*(body: untyped) = 
#    task("prepare", "prepare or configure package for building", body)
#template build*(body: untyped) = 
#    task("build", "build the package", body)
#template install*(body: untyped) = 
#    task("install", "Install the package to it's pkg folder", body)
#template meta*(body: untyped) =
#    task("meta", "Generate metadata for the package", body)



proc `download=`*(pkg: var Pkg, body: proc(pkg: PkgInstall)) =
    pkg.tasks.download = body

proc `extract=`*(pkg: var Pkg, body: proc(pkg: PkgInstall)) =
    pkg.tasks.extract = body

proc `prepare=`*(pkg: var Pkg, body: proc(pkg: PkgInstall)) =
    pkg.tasks.prepare = body

proc `build=`*(pkg: var Pkg, body: proc(pkg: PkgInstall)) =
    pkg.tasks.build = body

proc `install=`*(pkg: var Pkg, body: proc(pkg: PkgInstall)) =
    pkg.tasks.install = body

proc `meta=`*(pkg: var Pkg, body: proc(pkg: PkgInstall)) =
    pkg.tasks.meta = body
