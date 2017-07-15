## This module deals with generating and settings options. This is build system specific
## and may need to be manual to deal with (for example) makesfiles
import nre
import logging
import strfmt

type PkgOption* = object
    name*: string
    typ*: string
    default: string
    value*: string

type PkgOptions* = seq[PkgOption]

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