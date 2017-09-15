import os
const helpmsg = """
nenv.

nenv is a virtualenv like environment variable manager.

Usage:
  nenv list [options]
  nenv activate [options] <env_name>
  nenv dump

Options:
  -s, --shell=(fish | sh | powershell)
  -t, --target=<target_dir> 
    The target directory in which to search [default: STOW_DIR]

"""

import docopt
import strutils
import moustachu
const fish_script = """
begin
  {{#vars}}
  set -lx {{name}} {{value}}
  {{/vars}}
  fish
end
"""
proc main() =
  let args = docopt(helpmsg, version="nenv 1.0")
  var target = $args["--target"]
  if target == "STOW_DIR":
    if existsEnv("STOW_DIR"): 
      target = getEnv("STOW_DIR")
      target = target.parentDir()
    else: target = getCurrentDir()

  if args["list"]:
    echo "Listing:"
    
    if not (existsDir(target / "share/worts") or symlinkExists(target / "share/worts")):
      return
    for kind, path in walkDir(target / "share/worts"):
      if kind == pcDir and existsFile(path / "ENV"):
        echo splitPath(path).tail
  if args["activate"]:
    var path = target / "share/worts" / $args["<env_name>"] / "ENV"
    if not existsFile(path):
      echo "ERROR: env does not exist. try nstow list"
      quit(QuitFailure)
    if existsEnv("NENV_ACTIVE"):
      echo "ERROR: you can't nest environments, activate more at once"
    var ctx = newContext()
    var sections = newSeq[Context]()
    for line in lines(path):
      var splits = line.split('=')
      var section = newContext()
      section["name"] = splits[0]
      if splits[1][0] == '/':
        section["value"] = target / splits[1]
      else:
        section["value"] = splits[1]
      sections.add section
    ctx["vars"] = sections
    echo render(fish_script, ctx)

  

when isMainModule:
  main()