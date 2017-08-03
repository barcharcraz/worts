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

proc default_prepare*(info: PkgInstall) = 
    withDir info.build_dir:
        writeFile("CMakeCache.txt", cmake_writeopts(info.options))
        shell $$"""cmake -G"Ninja" -DCMAKE_PREFIX_PATH="${basedir}/install" -DCMAKE_INSTALL_PREFIX="${info.pkg_dir}" "${info.src_dir}"""

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


proc autotools_prepare*(pkg: PkgInstall) =
    withDir pkg.build_dir:
        shell $$"sh ${pkg.src_dir}/configure --prefix=${pkg.pkg_dir}"

proc autotools_build*(pkg: PkgInstall) = 
    withDir pkg.build_dir:
        shell $$"make"

proc autotools_install*(pkg: PkgInstall) =
    withDir pkg.build_dir:
        shell $$"make install"


proc cmake_build*(pkg: PkgInstall) =
    withDir pkg.build_dir:
        shell $$"cmake --build ."

proc cmake_install*(pkg: PkgInstall) =
    withDir pkg.build_dir:
        shell $$"cmake --build . --target install"

proc cmake_meta*(pkg: PkgInstall) =
    withDir pkg.build_dir:
        shell $$"""cmake --system-information "${pkg.pkg_dir}/META  """

