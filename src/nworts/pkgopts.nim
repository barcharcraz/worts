## This module deals with generating and settings options. This is build system specific
## and may need to be manual to deal with (for example) makesfiles
import nre

proc cmake_genopts*(cache: string) =
    ## ^ This generates options from a cmake cache file
    ## thus should contain both data types and names
    let opt = re"^(\w+):(\w+)=(\w+)$"
    