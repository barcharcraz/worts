import nworts
import os
var args = commandLineParams()
var meta = readFile(args[0])
var opts = cmake_readmeta(meta)
for opt in opts:
    echo opt.name & ":" & opt.typ & "=" & opt.value