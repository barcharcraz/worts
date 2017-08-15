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

template download*(body: untyped) =
    mixin pkg
    pkg.tasks.download = proc(pkg: PkgInstall) =
        body

template extract*(body: untyped) =
    mixin pkg
    pkg.tasks.extract = proc(pkg: PkgInstall) = 
        body

template prepare*(body: untyped) =
    mixin pkg
    pkg.tasks.prepare = proc(pkg: PkgInstall) =
        body

template build*(body: untyped) =
    mixin pkg
    pkg.tasks.build = proc(pkg: PkgInstall) =
        body

template install*(body: untyped) =
    mixin pkg
    pkg.tasks.install = proc(pkg: PkgInstall) =
        body

template meta*(body: untyped) =
    mixin pkg
    pkg.tasks.meta = proc(pkg: PkgInstall) =
        body
