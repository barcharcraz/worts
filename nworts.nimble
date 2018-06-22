# Package
version       = "0.1.0"
author        = "Charles Barto"
description   = "ports with nim"
license       = "GPL3"

# Dependencies
requires "nim >= 0.17.1"
requires "semver"
requires "docopt"
requires "moustachu"
requires "commandeer"
srcDir = "src"
bin = @["tools/dumpmeta",
        "tools/nenv",
        "tools/lspkgs",
        "tools/nstow"]
