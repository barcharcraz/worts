import nworts
import libarchive.libarchive
import sqlite3.sqlite3
import libiconv.libiconv
import fmt.fmt
import zlib.zlib
import qt.qt
import spdlog.spdlog

var db: seq[Pkg] = @[]
db.add qt.pkg()
db.add spdlog.pkg
db.add fmt.pkg
db.add libarchive.pkg
db.add sqlite3.pkg
db.add zlib.pkg

allow_multiple db