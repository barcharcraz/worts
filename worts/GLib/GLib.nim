import semver,nworts,sequtils,os
var pkg = initPkg()
pkg.name = "glib"
pkg.license = "GPLv3"
pkg.rel = 1
pkg.desc = "The GLib Library"
pkg.build_sys = pbsMeson
pkg.ver = "2.54.0"
pkg.url = "https://github.com/GNOME/glib/archive/2.54.0.tar.gz"
pkg.options.add(("with-docs", "no"))
pkg.options.add(("with-pcre", "system"))
pkg.options.add(("with-man", "no"))
pkg.options.add(("enable-dtrace", "false"))
pkg.options.add(("enable-systemtap", "false"))
pkg.options.add(("enable-libmount", "no"))

var pkgs = @[pkg]
pkg.ver = "2.56.0"
pkg.url = "https://github.com/GNOME/glib/archive/2.56.0.tar.gz"
pkg.options = @{
    "selinux": "false",
    "libmount": "false",
    "xattr": "false"
}
pkgs.add(pkg)
export_package(pkgs)