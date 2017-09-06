import pkgtypes
import strutils
import sequtils
import os

proc writeEnvFile*(pkg: PkgInstall) =
  var lines = pkg.env.map do (v: PkgEnvVar) -> string: v.name & "=" & v.value
  writeFile(pkg.pkg_dir / "share" / "worts" / pkg.name / "ENV", lines.join("\n"))