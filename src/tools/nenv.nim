const helpmsg = """
nenv.

nenv is a virtualenv like environment variable manager.

Usage:
  nenv list [options] <env_name>
  nenv activate [options] <env_name>
  nenv dump

Options:
  -s, --shell=(fish | sh | powershell)

"""

import docopt

proc main() =
  let args = docopt(helpmsg, version="nenv 1.0")
  

when isMainModule:
  main()