const helpmsg = """
nstow.

Usage:
    nstow [[-D | -S | -R] --target=<target-dir> --dir=<source-dir>]
    nstow (-h | --help)

Options:
    -h, --help      Show this message
    -D              Unstow
    -S              Stow
    -R              Restow
    -t, --target=<target-dir>    Target directory
    -d, --dir=<source-dir> Source directory
"""

import strutils
import docopt
import nworts.linking
import logging
import os
addHandler(newConsoleLogger())
let args = docopt(helpmsg, version = "nstow 1.0")
var fromdir = ""
if existsEnv("STOW_DIR"):
    fromdir = getEnv("STOW_DIR")
else:
    fromdir = getCurrentDir()
var todir = ""
if args.hasKey("--dir"): fromdir = $args["--dir"]


todir = fromdir.parentDir()
if args.haskey("--target"): todir = $args["--target"]
if args["-D"]:
    unlink(fromdir, todir)
elif args["-R"]:
    unlink(fromdir, todir)
    link(fromdir, todir)
elif args["-S"]:
    link(fromdir, todir)
else:
    link(fromdir, todir)
