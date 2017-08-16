import pkgtypes

proc format*(pkg: Pkg): string =
  return pkg.name & "\t\t" & pkg.ver