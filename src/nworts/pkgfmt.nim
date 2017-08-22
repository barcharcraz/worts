import pkgtypes

proc format*(pkg: Pkg): string =
  return pkg.name & "\t" & pkg.ver & "\t" & $pkg.platform