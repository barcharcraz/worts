# Package

version       = "0.1.0"
author        = "Charles Barto"
description   = "ports with nim"
license       = "GPL3"

# Dependencies
requires "nim >= 0.17.1"
requires "docopt"
srcDir = "src"
skipDirs = @["tools"]

task tools, "build nworts tools":
  exec "nim c -o:nstow src/tools/nstow.nim "
  exec "nim c -o:lspkgs src/tools/lspkgs.nim"

