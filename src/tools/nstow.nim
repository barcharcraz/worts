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
    -d, --dir=<source-dir>       Source directory [default: STOW_DIR]
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

var fromdir = $args["--dir"]
debug(fromdir)
if fromdir == "STOW_DIR":
    debug("Fromdir not set explicitly")
    if existsEnv("STOW_DIR"):
        debug("Using Stow dir")
        fromdir = getEnv("STOW_DIR")
    else:
        debug("Using Current dir")
        fromdir = getCurrentDir()
var todir = $args["--target"]
if todir == "STOW_DIR/..":
    todir = fromdir.parentDir()

fromdir = fromdir / $args["<pkg_name>"]
debug("From: ", fromdir)
debug("To: ", todir)
if args["-D"]:
    unlink(fromdir, todir)
elif args["-R"]:
    unlink(fromdir, todir)
    link(fromdir, todir)
elif args["-S"]:
    link(fromdir, todir)
else:
    link(fromdir, todir)
