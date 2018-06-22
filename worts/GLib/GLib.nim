import semver,nworts,sequtils,os,strfmt
var pkg = initPkg()
pkg.name = "glib"
pkg.license = "GPLv3"
pkg.rel = 1
pkg.desc = "The GLib Library"
pkg.build_sys = pbsMeson
pkg.ver = "2.54.0"
pkg.url = "https://github.com/GNOME/glib/archive/2.54.0.tar.gz"



export_package(pkg)