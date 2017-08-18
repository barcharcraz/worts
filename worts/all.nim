import nworts
import libarchive.libarchive
import sqlite3.sqlite3
import libiconv.libiconv
import fmt.fmt
import zlib.zlib
import qt.qt
import spdlog.spdlog
import boost.build
import boost.boost
import gflags.gflags
import libelektra.libelektra
import yaml_cpp.yaml_cpp

var db: seq[Pkg] = @[]
db.add qt.pkg()
db.add spdlog.pkg
db.add fmt.pkg
db.add libarchive.pkg
db.add sqlite3.pkg
db.add zlib.pkg
db.add build.pkg()
db.add boost.pkg
db.add gflags.pkg
db.add yaml_cpp.pkg
db.add libelektra.pkg

allow_multiple db