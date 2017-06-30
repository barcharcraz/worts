import semver,nworts,sequtils,os,strfmt, nake
var pkg: PkgInstall
pkg.name = "GLib"
pkg.license = "GPLv3"
pkg.rel = 1
pkg.desc = "The GLib Library"
pkg.vers = @[
    PkgVer(
        ver: "2.53.3",
        url: "https://download.gnome.org/sources/glib/2.53/glib-2.53.3.tar.xz.meta4", 
        hash: "ad727874057d369bf5f77f3ed32e2c50488672c99e62ee701a7f0ffdc47381a1"
    )
]
pkg = wort_defaults pkg
download default_download pkg
extract default_extract pkg
prepare autotools_prepare pkg
build autotools_build pkg
install autotools_install pkg