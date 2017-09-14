import pkgtypes
import strfmt
import osproc
import semver
import os
import sequtils
import uri
import pkgopts
import pkgexcept
import pkgenv
import pkglayout

proc shell(body: string): bool {.discardable.} = 
   result = execCmd(body) != ord(QuitFailure)

template withDir(dir: string, body: untyped) =
  var curdir = getCurrentDir()
  setCurrentDir(dir)
  body
  setCurrentDir(curdir)

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

proc cmake_edit*(pkg: PkgInstall) =
  var exe = findExe("cmake-gui")
  var process = startProcess(exe, pkg.build_dir, args = ["."],
                            options = {poParentStreams})
  discard waitForExit(process)

proc cmake_meta*(pkg: PkgInstall) =
  withDir pkg.build_dir:
    shell $$"""cmake -G"Ninja" --system-information "${pkg.pkg_dir}/share/worts/${pkg.name}/BUILDINFO.cmake"  """

proc boost_prepare*(pkg: PkgInstall) =
  var opts = pkg.options
  opts.add(("--prefix", "\"" & pkg.pkg_dir & "\""))
  opts.add(("--stagedir", "\"" & pkg.build_dir & "\""))
  withDir pkg.build_dir:
    writeFile("boostopts.txt", boost_writeopts(opts))

proc boost_edit*(pkg: PkgInstall) = 
  withDir pkg.build_dir:
    if hostOS == "windows":
      shell("notepad boostopts.txt")
    else:
      shell("open boostopts.txt")

proc boost_build*(pkg: PkgInstall) =
  var opts = boost_readopts(readFile(pkg.build_dir / "boostopts.txt"))
  withDir pkg.src_dir:
    shell($$"""b2  ${boost_writeopts(opts)} -j 8 stage """)

proc boost_install*(pkg: PkgInstall) =
  withDir pkg.src_dir:
    var opts = boost_readopts(readFile(pkg.build_dir / "boostopts.txt"))
    shell($$"""b2  ${boost_writeopts(opts)} -j 8 install""")




proc default_download*(info: PkgInstall) =
  var fname = info.pkg.downloaded_filename()
  var checksum = ""
  if info.hash != "":
    checksum = "--check-integrity=true --checksum=" & info.hash
  shell $$"""aria2c ${checksum} -d "${info.download_dir}" -o"${fname}" "${info.url}" """


proc default_extract*(info: PkgInstall) =
  var filename = info.pkg.downloaded_filename()
  shell $$"""bsdtar -C "${info.src_dir}" -xf "${info.download_dir}/${filename}" """
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
  of pbsBoostBuild: pkg.boost_prepare
  else:
    raise newException(BuildSystemUnsupportedException, "")

proc default_edit*(pkg: PkgInstall) =
  case pkg.build_sys
  of pbsCmake: pkg.cmake_edit
  of pbsBoostBuild: pkg.boost_edit
  else:
    raise newException(BuildSystemUnsupportedException, "")


proc default_build*(info: PkgInstall) = 
  case info.build_sys
  of pbsCmake: info.cmake_build
  of pbsAutotools: info.autotools_build
  of pbsBoostBuild: info.boost_build
  else:
    raise newException(BuildSystemUnsupportedException, "build system is not supported")

proc default_install*(pkg: PkgInstall) = 
  case pkg.build_sys
  of pbsCmake: pkg.cmake_install
  of pbsAutotools: pkg.autotools_install
  of pbsBoostBuild: pkg.boost_install
  else:
    raise newException(BuildSystemUnsupportedException, "")


proc default_meta*(pkg: PkgInstall) =
  writeEnvFile(pkg)
  case pkg.build_sys
  of pbsCmake: pkg.cmake_meta
  else:
    raise newException(BuildSystemUnsupportedException, "")

