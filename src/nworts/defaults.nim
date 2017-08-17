import pkgtypes
import strfmt
import nakelib
import semver
import sequtils
import uri
import pkgopts
import pkgexcept


when defined(packager):
  var basedir* = getCurrentDir()
else:
  var basedir* = expandTilde("~/.worts")


  proc layout*(pkg: Pkg, ver: string): PkgLayout =
    when defined(packager):
        result.pkg_dir = basedir / "pkg"
        result.build_dir = basedir / "build"
        result.src_dir = basedir / "source"
        result.download_dir = basedir
    else:
        var pkgdir = basedir / "pkg"
        var blddir = basedir / "bld"
        var pkgid = $$"${pkg.name}-${ver}-${pkg.rel}"
        result.pkg_dir = pkgdir / pkgid
        result.build_dir = blddir / pkgid / "build"
        result.src_dir = blddir / pkgid / "source"
        result.download_dir = basedir / "downloads"


proc createDirs*(layout: PkgLayout) = 
    createDir layout.build_dir
    createDir layout.pkg_dir
    createDir layout.download_dir
    createDir layout.src_dir

proc deleteDirs*(layout: PkgLayout) = 
    removeDir layout.build_dir
    removeDir layout.pkg_dir
    removeDir layout.download_dir
    removeDir layout.src_dir


proc wort_defaults*(p: Pkg): PkgInstall =
    var p = p
    result.pkg = p
    result.layout = layout(p, p.ver)
    createDirs(result.layout)
    case hostOS:
      of "linux": result.target.platform = ppLinux
      of "windows": result.target.platform = ppWin32
      else: raise newException(PlatformUnsupportedException, "")

    case hostCPU:
      of "amd64": result.target.arch = paamd64
      else: raise newException(PlatformUnsupportedException, "")

    when defined(isolated):
        # when isolated is defined we do our best to be self
        # sufficient
        putEnv("PATH", basedir / "wort_tools" / "bin")

proc wort_defaults*(p: PkgInstall): PkgInstall = wort_defaults(p.pkg)





proc autotools_prepare*(pkg: PkgInstall) =
  withDir pkg.build_dir:
    shell $$"sh ${pkg.src_dir}/configure --prefix=${pkg.pkg_dir}"

proc autotools_build*(pkg: PkgInstall) = 
  withDir pkg.build_dir:
    shell $$"make"

proc autotools_install*(pkg: PkgInstall) =
  withDir pkg.build_dir:
    shell $$"make install"


proc cmake_prepare*(pkg: PkgInstall) =
  withDir pkg.build_dir:
    writeFile("CMakeCache.txt", cmake_writeopts(pkg.options))
    shell $$"""cmake -G"Ninja" -DCMAKE_PREFIX_PATH="${basedir}/install" -DCMAKE_INSTALL_PREFIX="${pkg.pkg_dir}" "${pkg.src_dir}" """

proc cmake_build*(pkg: PkgInstall) =
  withDir pkg.build_dir:
    shell $$"cmake --build ."

proc cmake_install*(pkg: PkgInstall) =
  withDir pkg.build_dir:
    shell $$"cmake --build . --target install"

proc cmake_meta*(pkg: PkgInstall) =
  withDir pkg.build_dir:
    shell $$"""cmake --system-information "${pkg.pkg_dir}/META  """






proc default_download*(info: PkgInstall) =
  var ext = parseUri(info.url).path.splitFile.ext
  shell $$"""aria2c --allow-overwrite=true -d "${info.download_dir}" "${info.url}" """


proc default_extract*(info: PkgInstall) =
  var ext = parseUri(info.url).path.splitFile.ext
  var filename = parseUri(info.url).path.extractFilename
  # special case for metalinks
  # TODO: stop doing this and actually look in the metalink
  if ext == ".meta4": filename = splitfile(filename).name
  shell $$"""bsdtar -C ${info.src_dir} -xf "${info.download_dir}/${filename}" """
  var dirs = toSeq(walkDir(info.src_dir))
  if dirs.len == 1:
    echo "Moving directories"
    for kind, path in walkDir(dirs[0].path):
      moveFile(path, info.src_dir / extractFilename(path))
    removeDir dirs[0].path

proc default_prepare*(pkg: PkgInstall) = 
  case pkg.build_sys
  of pbsCmake: pkg.cmake_prepare
  of pbsAutotools: pkg.autotools_prepare
  else:
    raise newException(BuildSystemUnsupportedException, "")

proc default_build*(info: PkgInstall) = 
  case info.build_sys
  of pbsCmake: info.cmake_build
  of pbsAutotools: info.autotools_build
  else:
    raise newException(BuildSystemUnsupportedException, "build system is not supported")

proc default_install*(pkg: PkgInstall) = 
  case pkg.build_sys
  of pbsCmake: pkg.cmake_install
  of pbsAutotools: pkg.autotools_install
  else:
    raise newException(BuildSystemUnsupportedException, "")

proc default_meta*(pkg: PkgInstall) =
  case pkg.build_sys
  of pbsCmake: pkg.cmake_meta
  else:
    raise newException(BuildSystemUnsupportedException, "")

