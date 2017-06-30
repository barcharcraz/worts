import pkgtypes
import strfmt
import nakelib
import semver
import sequtils
import uri
proc default_download*(info: PkgInstall) =
    var ext = parseUri(info.url).path.splitFile.ext
    shell $$"""aria2c --allow-overwrite=true -d ${info.download_dir} -o "${info.name}-${$info.ver}${ext}" "${info.url}" """


proc default_extract*(info: PkgInstall) =
    shell $$"""bsdtar -C ${info.src_dir} -xf "${info.download_dir}/${info.name}-${$info.ver}.zip" """
    var dirs = toSeq(walkDir(info.src_dir))
    if dirs.len == 1:
        echo "Moving directories"
        for kind, path in walkDir(dirs[0].path):
            moveFile(path, info.src_dir / extractFilename(path))
        removeDir dirs[0].path

proc default_prepare*(info: PkgInstall) = 
    withDir info.build_dir:
        shell $$"""cmake -G"Ninja" -DCMAKE_INSTALL_PREFIX=${info.pkg_dir} ${info.src_dir}"""

proc default_build*(info: PkgInstall) = 
    withDir info.build_dir:
        shell $$"cmake --build ."

proc default_install*(info: PkgInstall) = 
    withDir info.build_dir:
        shell $$"cmake --build . --target install"