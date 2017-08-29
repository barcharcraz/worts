# Package

version       = "0.1.0"
author        = "Charles Barto"
description   = "ports with nim"
license       = "GPL3"

# Dependencies
requires "nim >= 0.17.1"
requires "docopt"
srcDir = "src"
skipDirs = @["src/tools"]
bin = @["tools/nstow"]
