import semver,nworts,sequtils,os,strfmt
var pkg = initPkg()
pkg.name = "GLib"
pkg.license = "GPLv3"
pkg.rel = 1
pkg.desc = "The GLib Library"
pkg.build_sys = pbsMeson
pkg.ver = "2.54.0"
pkg.url = "https://download.gnome.org/sources/glib/2.54/glib-2.54.0.tar.xz.meta4"



export_package @[pkg]