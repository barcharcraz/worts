import nworts, os, ospaths, nakelib

var pkg* = newSeq[Pkg]()

proc install_vimba(pkg: PkgInstall, arch: string) =
  createDir(pkg.pkg_dir / "lib")
  createDir(pkg.pkg_dir / "include" / "vimba")
  for typ, path in walkDir(pkg.src_dir / "VimbaC" / "Include"):
    assert(typ == pcFile)
    var (_, tail) = splitPath(path)
    copyFile(path, pkg.pkg_dir / "include" / "vimba" / tail)
  
  var libpath = pkg.src_dir / "VimbaC" / "DynamicLib" / arch
  for typ, path in walkDir(libpath):
    var (_, tail) = splitPath(path)
    copyFile(path, pkg.pkg_dir / "lib" / tail)

var p = initPkg()
p.name = "VimbaC"
p.license = "Propriatary"
p.ver = "2.1"
p.desc = "Vimba sdk for allied vision cameras"
p.rel = 1
p.tasks = PkgTasks()
p.hash = "sha-256=97b112282b136ab1f6f388136465665c4e8f2be208c921ad5ef009658fbee020"
p.url = "https://www.alliedvision.com/fileadmin/content/software/software/Vimba/Vimba_v2.1_Linux.tgz"
p.platform = {ppLinux}
p.arch = {paamd64}
p.download = default_download
p.extract = default_extract
p.install:
  install_vimba(pkg, "x86_64bit")


pkg.add p
p.arch = {pax86}
p.install: install_vimba(pkg, "x86_32bit")

proc install_vimbacpp(pkg: PkgInstall, arch: string) =
  createDir(pkg.pkg_dir / "lib")
  createDir(pkg.pkg_dir / "include" / "vimba")
  for typ, path in walkDir(pkg.src_dir / "VimbaCPP" / "Include"):
    assert(typ == pcFile)
    var (_, tail) = splitPath(path)
    copyFile(path, pkg.pkg_dir / "include" / "vimba" / tail)
  
  var libpath = pkg.src_dir / "VimbaCPP" / "DynamicLib" / arch
  for typ, path in walkDir(libpath):
    var (_, tail) = splitPath(path)
    copyFile(path, pkg.pkg_dir / "lib" / tail)

p.name = "VimbaCPP"
p.arch = {paamd64}
p.install: install_vimbacpp(pkg, "x86_64bit")

pkg.add p
p.arch = {pax86}
p.install: install_vimbacpp(pkg, "x86_32bit")
pkg.add p

p.name = "VimbaGigETL"
p.arch = {paamd64}
p.install:
  createDir(pkg.pkg_dir / "lib" / "vimba")
  copyFile(pkg.src_dir / "VimbaGigETL" / "CTI" / "x86_64bit" / "VimbaGigETL.cti", pkg.pkg_dir / "lib" / "vimba" / "VimbaGigETL.cti")
  copyFile(pkg.src_dir / "VimbaGigETL" / "CTI" / "x86_64bit" / "VimbaGigETL.xml", pkg.pkg_dir / "lib" / "vimba" / "VimbaGigETL.xml")

pkg.add p

p.arch = {pax86}
p.install:
  createDir(pkg.pkg_dir / "lib" / "vimba")
  copyFile(pkg.src_dir / "VimbaGigETL" / "CTI" / "x86_32" / "VimbaGigETL.cti", pkg.pkg_dir / "lib" / "vimba" / "VimbaGigETL.cti")
  copyFile(pkg.src_dir / "VimbaGigETL" / "CTI" / "x86_32" / "VimbaGigETL.xml", pkg.pkg_dir / "lib" / "vimba" / "VimbaGigETL.xml")
pkg.add p

p.name = "VimbaUSBTL"
p.arch = {paamd64}
p.install:
  createDir(pkg.pkg_dir / "lib" / "vimba")
  copyFile(pkg.src_dir / "VimbaUSBTL" / "CTI" / "x86_64" / "VimbaUSBTL.cti", pkg.pkg_dir / "lib" / "vimba" / "VimbaUSBTL.cti")
  copyFile(pkg.src_dir / "VimbaUSBTL" / "CTI" / "x86_64" / "VimbaUSBTL.xml", pkg.pkg_dir / "lib" / "vimba" / "VimbaUSBTL.xml")
pkg.add p

p.arch = {pax86}
p.install:
  createDir(pkg.pkg_dir / "lib" / "vimba")
  copyFile(pkg.src_dir / "VimbaUSBTL" / "CTI" / "x86_32" / "VimbaUSBTL.cti", pkg.pkg_dir / "lib" / "vimba" / "VimbaUSBTL.cti")
  copyFile(pkg.src_dir / "VimbaUSBTL" / "CTI" / "x86_32" / "VimbaUSBTL.xml", pkg.pkg_dir / "lib" / "vimba" / "VimbaUSBTL.xml")

allow_multiple pkg