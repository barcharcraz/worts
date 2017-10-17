import os
import osproc
import parsecfg
import sequtils
import strtabs
import docopt
import strutils
import future
import moustachu
import tables
const helpmsg = """
nenv.

nenv is a virtualenv like environment variable manager.
it just runs a new process using env vars from an ini file.

Nnv sets the NENV_ENV env var to the name of the current envirenment.
This is useful if you'd like to show this information on your PS1

Usage:
  nenv [options] list 
  nenv [options] run [--isolated] <env_name> <command_name>
  nenv dump [<env_name>]

Options:
  -t, --target=<target_dir> 
    The target directory in which to search [default: STOW_DIR]
Run_Options:
  -i, --isolated  use ONLY the env vars from the read ENV files, don't
                  use any from the current env

Subcommands:
  nenv-list:
    simply list available envirenments you may want to load
  nenv-run:
    run a command using env vars from an nenv ini file
  nenv-dump:
    simply dump out env vars in a NAME=VALUE format

Examples:
  nenv run WortEnv bash
"""


const output = """
{{#vars}}
{{name}}={{value}}
{{/vars}}
"""

proc fixup_vars(prefix: string, envpath: string): StringTableRef =
  ## take an env file with relative paths and fix it up
  ## relative to the prefix
  var envcfg = loadConfig(envpath)
  for key, value in envcfg[""]:
    if value[0] == '/':
      envcfg.setSectionKey("", key, prefix / value)
  result = newStringTable(toSeq(envcfg[""].pairs()))

proc merge_vars(a, b: StringTableRef): StringTableRef =
  result = newStringTable(modeCaseSensitive)
  result[] = a[]
  for key, value in b:
    if key notin result:
      result[key] = value
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
    if not (existsDir(target / "share/nenv") or symlinkExists(target / "share/nenv")):
      return
    for kind, path in walkDir(target / "share/nenv"):
      if kind in {pcDir, pcLinkToDir} and splitFile(path).ext == ".env":
        echo splitPath(path).tail
  if args["run"]:
    var path = target / "share/worts" / $args["<env_name>"] / "ENV"
    if not existsFile(path):
      echo "ERROR: env does not exist. try nstow list"
      quit(QuitFailure)
    if existsEnv("NENV_ACTIVE"):
      echo "ERROR: you can't nest environments, activate more at once"
    var env = fixup_vars(target, path)
    # get envParis into a usable format for us, also untaint it
    var currentEnv = newStringTable(map(toSeq(envPairs()), (x) => (x.key.string, x.value.string)))
    if not  args["--isolated"]:
      env = merge_vars(currentEnv, env)
    env["NENV_ENV"] = $args["<env_name>"]
    var process = startProcess($args["<command_name>"], "", [], 
                               env, {poUsePath, poParentStreams})
    quit waitForExit(process)

  

when isMainModule:
  main()