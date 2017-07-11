import nakelib

template download*(body: untyped) = 
    task("download", "download package sources or binaries from upstream", body)
template extract*(body: untyped) = 
    task("extract", "extract package sources or binaries", body)
template prepare*(body: untyped) = 
    task("prepare", "prepare or configure package for building", body)
template build*(body: untyped) = 
    task("build", "build the package", body)
template install*(body: untyped) = 
    task("install", "Install the package to it's pkg folder", body)
template meta*(body: untyped) =
    task("meta", "Generate metadata for the package", body)