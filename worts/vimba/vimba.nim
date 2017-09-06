import nworts, os, ospaths, nakelib

var pkg* = newSeq[Pkg]()

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
p.arch = {paamd64, pax86}
p.download = default_download
p.extract = default_extract
p.install:
  createDir(pkg.pkg_dir / "lib")
  createDir(pkg.pkg_dir / "include" / "vimba")
  for typ, path in walkDir(pkg.src_dir / "VimbaC" / "Include"):
    assert(typ == pcFile)
    var (_, tail) = splitPath(path)
    copyFile(path, pkg.pkg_dir / "include" / "vimba" / tail)
  
  var libpath: string
  case pkg.target.arch
  of pax86: libpath = pkg.src_dir / "VimbaC" / "DynamicLib" / "x86_32bit"
  of paamd64: libpath = pkg.src_dir / "VimbaC" / "DynamicLib" / "x86_64bit"
  else: raise newException(ArchError, "")
  for typ, path in walkDir(libpath):
    var (_, tail) = splitPath(path)
    copyFile(path, pkg.pkg_dir / "lib" / tail)


pkg.add p

p.name = "VimbaCPP"
p.install:
  createDir(pkg.pkg_dir / "lib")
  createDir(pkg.pkg_dir / "include" / "vimba")
  for typ, path in walkDir(pkg.src_dir / "VimbaCPP" / "Include"):
    assert(typ == pcFile)
    var (_, tail) = splitPath(path)
    copyFile(path, pkg.pkg_dir / "include" / "vimba" / tail)
  
  var libpath: string
  case pkg.target.arch
  of pax86: libpath = pkg.src_dir / "VimbaCPP" / "DynamicLib" / "x86_32bit"
  of paamd64: libpath = pkg.src_dir / "VimbaCPP" / "DynamicLib" / "x86_64bit"
  else: raise newException(ArchError, "")
  for typ, path in walkDir(libpath):
    var (_, tail) = splitPath(path)
    copyFile(path, pkg.pkg_dir / "lib" / tail)

pkg.add p

proc get_vm_arch(a: PkgArch): string =
  case a
  of paamd64: result = "x86_64bit"
  of pax86: result = "x86_32bit"
  else: raise newException(ArchError, "")

p.name = "VimbaGigETL"
p.install:
  createDir(pkg.pkg_dir / "lib" / "vimba")
  copyFile(pkg.src_dir / "VimbaGigETL" / "CTI" / get_vm_arch(pkg.target.arch) / "VimbaGigETL.cti", pkg.pkg_dir / "lib" / "vimba" / "VimbaGigETL.cti")
  copyFile(pkg.src_dir / "VimbaGigETL" / "CTI" / get_vm_arch(pkg.target.arch) / "VimbaGigETL.xml", pkg.pkg_dir / "lib" / "vimba" / "VimbaGigETL.xml")

pkg.add p

p.name = "VimbaUSBTL"
p.install:
  createDir(pkg.pkg_dir / "lib" / "vimba")
  copyFile(pkg.src_dir / "VimbaUSBTL" / "CTI" / get_vm_arch(pkg.target.arch) / "VimbaUSBTL.cti", pkg.pkg_dir / "lib" / "vimba" / "VimbaUSBTL.cti")
  copyFile(pkg.src_dir / "VimbaUSBTL" / "CTI" / get_vm_arch(pkg.target.arch) / "VimbaUSBTL.xml", pkg.pkg_dir / "lib" / "vimba" / "VimbaUSBTL.xml")

allow_multiple pkg