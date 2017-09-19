const helpmsg = """
nstow.

Usage:
    nstow [options] [-D | -S | -R] [--target=<target-dir>] [--dir=<source-dir>] <pkg_name>
    nstow (-h | --help)

Options:
    -h, --help      Show this message
    -v              be verbose
    -D              Unstow
    -S              Stow
    -R              Restow
    -t, --target=<target-dir>    Target directory [default: STOW_DIR/..]
    -d, --dir=<source-dir> Source directory [default: STOW_DIR]
"""

import strutils
import docopt
import nworts.linking
import logging
import os
let args = docopt(helpmsg, version = "nstow 1.0")
if args["-v"]:
    addHandler(newConsoleLogger(lvlAll))
else:
    addHandler(newConsoleLogger(lvlError))

var fromdir = ""
if existsEnv("STOW_DIR"):
    fromdir = getEnv("STOW_DIR")
else:
    fromdir = getCurrentDir()
var todir = ""
if args.hasKey("--target"): fromdir = $args["--target"]


todir = fromdir.parentDir()
if args.haskey("--dir"): todir = $args["--dir"]

fromdir = fromdir / $args["<pkg_name>"]
if args["-D"]:
    unlink(fromdir, todir)
elif args["-R"]:
    unlink(fromdir, todir)
    link(fromdir, todir)
elif args["-S"]:
    link(fromdir, todir)
else:
    link(fromdir, todir)
