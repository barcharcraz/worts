
import nworts
import libarchive.libarchive
import sqlite3.sqlite3
import libiconv.libiconv
import fmt.fmt
import zlib.zlib
import qt.qt
import vimba.vimba
import spdlog.spdlog
import boost.build
import oiio.oiio
import boost.boost
import gflags.gflags
import libelektra.libelektra
import yaml_cpp.yaml_cpp
import semver
import libtiff.libtiff
import wortenv


var db: seq[Pkg] = @[]
db.add wortenv.nworts_pkg()
db.add qt.nworts_pkg()
db.add spdlog.nworts_pkg()
db.add fmt.nworts_pkg()
db.add libarchive.nworts_pkg()
db.add libtiff.nworts_pkg()
db.add sqlite3.nworts_pkg()
db.add zlib.nworts_pkg()
db.add build.nworts_pkg()
db.add boost.nworts_pkg()
db.add gflags.nworts_pkg()
db.add yaml_cpp.nworts_pkg()
db.add libelektra.nworts_pkg()
db.add oiio.nworts_pkg()
db.add vimba.nworts_pkg()
allow_multiple db