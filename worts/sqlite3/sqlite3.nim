import nake
import nworts
import semver
import strfmt
import subfield
var pkg: Pkg
pkg.name = "sqlite3"
pkg.license = "Public Domain"
pkg.rel = 1
pkg.desc = "The Sqlite database library"
pkg.vers = @[
    PkgVer(
        ver: v"3.19.3",
        url: "https://www.sqlite.org/2017/sqlite-amalgamation-3190300.zip",
        hash: "130185efe772a7392c5cecb4613156aba12f37b335ef91e171c345e197eabdc1"
    )
]
var info = wort_defaults(pkg)
#echo info.name
echo info.download_dir
#[[
download:
    shell $$"""aria2c -d ${info.download_dir} -o "${info.name}-3.19.3.zip" "${info.ver.url}" """

extract:
    shell $$"""bsdtar -C ${layout.src_dir} -xf "${layout.download_dir}/${pkg.name}-3.19.3.zip" """
]]#