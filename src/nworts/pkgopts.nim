## This module deals with generating and settings options. This is build system specific
## and may need to be manual to deal with (for example) makesfiles
import nre
import logging
import strformat
import strutils
import json
import pkglayout
import osproc
import pkgtypes

proc default*(self: PkgOption): string = self.default

proc `==`*(a: PkgOption, b: PkgOption): bool =
    result = a.name == b.name

proc `==`*(a: PkgOption, b: string): bool = 
    result = a.name == b

proc boost_defaultopts*(): PkgOptions =
    result = @[]
    result.add(("--layout", "tagged"))
    result.add(("variant", "debug"))
    result.add(("link", "static"))
    result.add(("threading", "multi"))
    result.add(("runtime-link", "shared"))

proc boost_readopts*(cache: string): PkgOptions =
    result = @[]
    for line in cache.split(' '):
        var parts = line.split('=')
        if parts.len == 0: discard
        elif parts.len == 1:
            result.add((parts[0], ""))
        else:
            result.add((parts[0], parts[1]))

proc boost_writeopts*(options: PkgOptions): string =
    var optstrings: seq[string] = @[]
    for opt in options:
        if opt.value != "": optstrings.add(opt.name & "=" & opt.value)
        else: optstrings.add(opt.name)
    result = optstrings.join(" ")


proc cmake_genopts*(cache: string): PkgOptions =
    ## ^ This generates options from a cmake cache file
    ## thus should contain both data types and names
    let opt = re"(*ANYCRLF)(?m)^(\w+):(\w+)=(\w+)$"
    result = @[]
    for match in cache.findIter(opt):
        var caps = match.captures()
        info("adding option {} of type {} with default {}".format(caps[0], caps[1], caps[2]))
        var option = (caps[0], caps[2])
        result.add(option)

proc cmake_writeopts*(options: PkgOptions): string =
    result = ""
    for opt in options:
        result &= opt.name & "=" & opt.value & "\n"

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

proc meson_defaultopts*(): PkgOptions =
    result = @[]
proc meson_readopts*(builddir: string): PkgOptions =
    var meson_output = execProcess("meson", [builddir, "introspect", "--buildoptions"])
    var json_out = parseJson(meson_output)
    echo json_out

#[[
proc meson_guessopts*(meson_options: string): PkgOptions =
    ## Reads meson_options.txt and outputs a possible set of package options
    var opts = readFile(meson_options)
    let regex = re"(*ANYCRLF)(?m)(?s)option\((?<body>.+?)\)"
    for match in opts.findIter(regex):
        var body = match.captures["body"]
]]#