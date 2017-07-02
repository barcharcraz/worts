## this file setus up cygwin. It's nice for bootstraping a build system
import nworts, nake, os, strfmt
var pkg = initPkgInstall()
pkg.name = "Cygwin"
pkg.desc = "The Cygwin environment for winodws"
pkg.platforms = {ppWin32}
pkg.types = { ptBinary }

pkg.vers &= initPkgVer(
    ver = "2.8.0",
    url = "https://cygwin.com/setup-x86_64.exe",
    hash = "83F128C7CD121E455FD3F5CC732ACA8F313D0EB1ACCBD97E99FC14F2DF2FE7EB",
    arch = {paamd64},
    platform = {ppWin32}
)
pkg = wort_defaults(pkg)
download default_download pkg
extract: discard