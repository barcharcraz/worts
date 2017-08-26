import nworts, os, strfmt, strutils

var pkg*: seq[Pkg] = @[]
const components = @[
    "atomic",
    "chrono",
    "container",
    "context",
    "coroutine",
    "date_time",
    "exception",
    "fiber",
    "filesystem",
    "graph",
    "graph_parallel",
    "iostreams",
    "locale",
    "log",
    "math",
    "metaparse",
    "mpi",
    "program_options",
    "python",
    "random",
    "regex",
    "serialization",
    "signals",
    "stacktrace",
    "system",
    "test",
    "thread",
    "timer",
    "type_erasure",
    "wave"
]
pkg.add initPkg()

pkg[^1].name = "boost"
pkg[^1].license = "boost"
pkg[^1].desc = "The Boost c++ libraries"
pkg[^1].build_sys = pbsBoostBuild
pkg[^1].ver = "1.64.0"
pkg[^1].url = "https://dl.bintray.com/boostorg/release/1.64.0/source/boost_1_64_0.tar.gz"
pkg[^1].options = boost_defaultopts()
for comp in components:
    pkg[^1].options.add(("--without-" & comp, ""))

pkg.add pkg[^1]
pkg[^1].ver = "1.65.0"
pkg[^1].url = "https://dl.bintray.com/boostorg/release/1.65.0/source/boost_1_65_0.tar.gz"
