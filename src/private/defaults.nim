import pkgtypes
import strfmt
import nakelib
template default_download*(info: PkgInstall) =
    shell $$"""aria2c --allow-overwrite=true -d ${info.download_dir} -o "${info.name}-3.19.3.zip" "${info.url}" """


template default_extract*(info: PkgInstall) =
    shell $$"""bsdtar -C ${info.src_dir} -xf "${info.download_dir}/${pkg.name}-3.19.3.zip" """
    var dirs = toSeq(walkDir(info.src_dir))
    if dirs.len == 1:
        echo "Moving directories"
        for kind, path in walkDir(dirs[0].path):
            moveFile(path, info.src_dir / extractFilename(path))
        removeDir dirs[0].path

template default_prepare*(info: PkgInstall) = 
    withDir info.build_dir:
        shell $$"""cmake -G"Ninja" -DCMAKE_INSTALL_PREFIX=${info.pkg_dir} ${info.src_dir}"""

template default_build*(info: PkgInstall) = 
    withDir info.build_dir:
        shell $$"cmake --build ."

template default_install*(info: PkgInstall) = 
    withDir info.build_dir:
        shell $$"cmake --build . --target install"