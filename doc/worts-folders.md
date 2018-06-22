# Folders

Worts installs things in folders. By default the root is at ~/.worts.
inside this you will find:

- pkg
    - some-package-1.2.3-4
       - <package specific things>
- bld
   - some-package-1.2.3-4
        - source
        - build
- install
   - you control this folder
- download


pkg is where packages get installed. If you want to distribute things around your team this is the
directory to archive. Bld is the build prefix and contains working space for building packages. Install
is where you can copy packages that you want in a global prefix. Finally, download is where things are downloaded into.
You can remove bld and download if you need to reclaim space.

If you define "packager" when building a wort then an alternate structure is defined that installs into a
subdirectory of the current dir. This is for easier package development (less nested folders)