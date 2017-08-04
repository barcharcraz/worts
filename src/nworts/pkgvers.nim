## deals with splitting up packages by version
import pkgtypes

## verspecs are used to specify what
## version of a package something applies to
## thus they don't care aobut the download url or
## hash.
## specs are matched as follows:
##      - each field is matched. from a set of vers the ver closest to the target, but smaller is a match
##        for arch and platform the smallest set that fully contains all items in the target's arch/platform matches
##        ver is only considered at all for the best platform/arch match
##      - if there are multiple verspecs left that match the same amount it is considered an error and an exception is thrown
type VerSpec* = object
    ver*: string
    arch*: set[PkgArch]
    platform*: set[PkgPlatform]
  
proc initVerSpec*(ver: string, arch: set[PkgArch], platform: set[PkgPlatform]): VerSpec =
    result.ver = ver
    result.arch = arch
    result.platform = platform

proc initVerSpec*(ver: string): VerSpec =
    result.ver = ver
    result.arch = {low(PkgArch)..high(PkgArch)}
    result.platform = {low(PkgPlatform)..high(PkgPlatform)}