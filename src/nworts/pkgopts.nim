## This module deals with generating and settings options. This is build system specific
## and may need to be manual to deal with (for example) makesfiles
import nre
import logging
import strfmt
import strutils
import pkglayout
import pkgtypes

proc default*(self: PkgOption): string = self.default

proc `==`*(a: PkgOption, b: PkgOption): bool =
    result = a.name == b.name

proc `==`*(a: PkgOption, b: string): bool = 
    result = a.name == b

proc initPkgOption*(name: string): PkgOption = 
    result.name = name
    result.typ = "BOOL"
    result.default = "OFF"
    result.value = result.default

proc initPkgOption*(name: string, typ: string, default: string): PkgOption =
    result.name = name
    result.typ = typ
    result.default = default
    result.value = default

proc boost_defaultopts*(pkg: Pkg): PkgOptions =
    result = @[]
    var dirs = layout(pkg)
    result.add initPkgOption("--prefix", "STRING", dirs.pkg_dir)
    result.add initPkgOption("--stagedir", "STRING", dirs.build_dir)
    result.add initPkgOption("toolset", "STRING", "gcc")
    result.add initPkgOption("variant", "STRING", "debug")
    result.add initPkgOption("link", "STRING", "static")
    result.add initPkgOption("threading", "STRING", "multi")
    result.add initPkgOption("runtime-link", "STRING", "shared")

proc cmake_genopts*(cache: string): PkgOptions =
    ## ^ This generates options from a cmake cache file
    ## thus should contain both data types and names
    let opt = re"(*ANYCRLF)(?m)^(\w+):(\w+)=(\w+)$"
    result = @[]
    for match in cache.findIter(opt):
        var caps = match.captures()
        info("adding option {} of type {} with default {}".fmt(caps[0], caps[1], caps[2]))
        var option = initPkgOption(caps[0], caps[1], caps[2])
        result.add(option)

proc cmake_writeopts*(options: PkgOptions): string =
    result = ""
    for opt in options:
        result &= opt.name & ":" & opt.typ & "=" & opt.value & "\n"

proc cmake_readmeta*(meta: string): PkgOptions =
    const cachestart = """
=================================================================
=== ../CMakeCache.txt
=================================================================
"""
    const cacheend = """
=================================================================
"""
    result = @[]
    var startidx = meta.find(cachestart)
    var endidx = meta.find(cacheend, startidx+len(cachestart))
    var cache = meta[startidx+len(cachestart)..endidx]
    result = cmake_genopts(cache)

