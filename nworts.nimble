# Package

version       = "0.1.0"
author        = "Charles Barto"
description   = "ports with nim"
license       = "GPL3"

# Dependencies
requires "nim >= 0.17.1"
requires "semver"
requires "strfmt"
requires "docopt"
requires "moustachu"
requires "commandeer"
srcDir = "src"
bin = @["tools/dumpmeta",
        "tools/nenv",
        "tools/lspkgs",
        "tools/nstow"]

task tools, "build nworts tools":
  exec "nim c -o:nstow src/tools/nstow.nim "
  exec "nim c -o:lspkgs src/tools/lspkgs.nim"
  exec "nim c -o:nenv src/tools/nenv"

