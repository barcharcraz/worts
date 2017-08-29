const helpmsg = """
nstow.

Usage:
    nstow [-D | -S] --target=<target-dir> --directory=<source-dir>
    nstow (-h | --help)

Options:
    -h, --help      Show this message
    -D              Unstow
    -S              Stow
    -t, --target=<target-dir>    Target directory
    -d, --directory=<source-dir> Source directory
"""

import strutils
import docopt
import nworts.linking
import logging
addHandler(newConsoleLogger())
let args = docopt(helpmsg, version = "nstow 1.0")
if args["-D"]:
    unlink($args["--directory"], $args["--target"])
else:
    link($args["--directory"], $args["--target"])
