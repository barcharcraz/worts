# Package
import strformat
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


mkDir "builddir/tools"
task tools, "build nworts tools":
        withDir "builddir/tools":
                exec fmt"nim c {thisDir()}/src/tools/nstow.nim "
                exec fmt"nim c {thisDir()}/src/tools/lspkgs.nim"
                exec fmt"nim c {thisDir()}/src/tools/nenv"