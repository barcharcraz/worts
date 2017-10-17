import pkgtypes
{.experimental.}
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



proc `download=`*(pkg: var Pkg, body: proc(pkg: PkgInstall) {.nimcall.}) =
    pkg.tasks.download = body

proc `extract=`*(pkg: var Pkg, body: proc(pkg: PkgInstall) {.nimcall.}) =
    pkg.tasks.extract = body

proc `prepare=`*(pkg: var Pkg, body: proc(pkg: PkgInstall) {.nimcall.}) =
    pkg.tasks.prepare = body

proc `build=`*(pkg: var Pkg, body: proc(pkg: PkgInstall) {.nimcall.}) =
    pkg.tasks.build = body

proc `install=`*(pkg: var Pkg, body: proc(pkg: PkgInstall) {.nimcall.}) =
    pkg.tasks.install = body

proc `meta=`*(pkg: var Pkg, body: proc(pkg: PkgInstall) {.nimcall.}) =
    pkg.tasks.meta = body

template download*(tgt: typed, body: untyped) =
    tgt.tasks.download = proc (pkg: PkgInstall) = 
        var pkg {.inject.} = pkg 
        body

template extract*(tgt: untyped, body: untyped) =
    tgt.tasks.extract = proc (pkg: PkgInstall) = 
        var pkg {.inject.} = pkg 
        body

template prepare*(tgt: typed, body: untyped) =
    tgt.tasks.prepare = proc (pkg: PkgInstall) = 
        var pkg {.inject.} = pkg 
        body

template build*(tgt: typed, body: untyped) =
    tgt.tasks.build = proc (pkg: PkgInstall) = 
        var pkg {.inject.} = pkg 
        body
    
template install*(tgt: typed, body: untyped) =
    tgt.tasks.install = proc (pkg: PkgInstall) = 
        var pkg {.inject.} = pkg 
        body
