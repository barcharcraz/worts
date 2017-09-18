import os
import parsecfg
import sequtils
const helpmsg = """
nenv.

nenv is a virtualenv like environment variable manager.

Usage:
  nenv list [options]
  nenv run [options] <env_name> <command_name>
  nenv dump

Options:
  -s, --shell=(fish | sh | powershell)
  -t, --target=<target_dir> 
    The target directory in which to search [default: STOW_DIR]

"""

import docopt
import strutils
import moustachu
import tables
const output = """
{{#vars}}
{{name}}={{value}}
{{/vars}}
"""

proc fixup_vars(prefix: string, envpath: string): OrderedTableRef[string, string] =
  ## take an env file with relative paths and fix it up
  ## relative to the prefix
  var envcfg = loadConfig(envpath)
  for key, value in envcfg[""]:
    if value[0] == '/':
      envcfg.setSectionKey("", key, prefix / value)
  result = envcfg[""]

proc merge_vars(a, b: OrderedTableRef): OrderedTableRef =
  result = newOrderedTable()
  result[] = a[]
  for key, value in b:
    if key notin result:
      result.add(key, value)
    else:
      result[key] = result[key] & PathSep & value


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
      if kind in {pcDir, pcLinkToDir} and existsFile(path / "ENV"):
        echo splitPath(path).tail
  if args["run"]:
    var path = target / "share/worts" / $args["<env_name>"] / "ENV"
    if not existsFile(path):
      echo "ERROR: env does not exist. try nstow list"
      quit(QuitFailure)
    if existsEnv("NENV_ACTIVE"):
      echo "ERROR: you can't nest environments, activate more at once"
    var envVars = fixup_vars(target, path)
    var currentEnv = newOrderedTable[string, string]()
    currentEnv[] = toOrderedTable(toSeq(envPairs()))
    var env = merge_vars(currentEnv, envVars)


  

when isMainModule:
  main()