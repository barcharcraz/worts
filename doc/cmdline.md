# Command Line syntax

there are two modes for generated command line binaries. The single package mode is quite simple. It is simply

```txt
Package.

Usage:
    package <task>
```

task may be "all" which will run everything needed to install the package


The multi package mode is more complex, since multiple packages can be in the "database" and must be searched. You can specify a package using a package spec.
If it returns one version then we'll install that one, otherwise we'll print a list
of possible matches.
