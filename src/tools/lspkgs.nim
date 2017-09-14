## lists packages in a given directory, just one file per line.
import docopt
import os
import strutils

const helppage = """

lspkgs.

Usage:
  lspkgs <directory>

"""


proc main() =
  let args = docopt(helppage, version = "lspkgs 1.0")
  for kind, path in walkDir($args["<directory>"]):
    case kind:
      of pcDir:
        let dirname = splitPath(path).tail
        let modulefile = path / dirname
        if existsFile(modulefile & ".nim"): echo strip(modulefile, chars={'.','/'})
      of pcFile:
        let (dir, dirname, ext) = splitFile(path)
        if ext == ".nim" and not existsDir(path / dirname):
          echo strip(dir / dirname, chars = {'.', '/'})
      else: discard

when isMainModule:
  main()