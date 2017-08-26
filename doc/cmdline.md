# Command Line syntax

there are two modes for generated command line binaries. The single package mode is quite simple. It is simply

```txt
Package.

Usage:
    package <task>
```

task may be "all" which will run everything needed to install the package

The multi package mode is more complex, since multiple packages can be in the "database" and must be searched