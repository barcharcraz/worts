# overview

These are the docs for the nim version of worts and
the associated libraries and utilities. the idea is that ports are written as nakefiles and then
built and installed much like a "real" bsd port. Since they
are written in nim you compile them to executables and the target
does not need much of a runtime. A secondary goal is to understand build systems enough to keep track of what options
are available for a given package and which ones were selected. This inforamtion
is used to make package development easier.

# versioning

By default the latest version of a package is installed, 
we keep records of the release and hash of old versions though. To account for fixed bugs or
build system changes we use a matching scheme agains the `PkgVer` structure. This allows
seperating recipies for different systems, arch, or versions. This is also very nice for windows
specific build system issues. Please note that the PkgVer structure for every version should be listed
in the main wortfile.

# Cross compiling
Worts are assumed to be cross platform. They should error out at compile time when
a platform is not supported. They are NOT assumed to support building targets for all platforms
(although that is the default).