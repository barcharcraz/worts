## package interface types and conversion functions

type CPkg* {.exportc: "nworts_pkg".} = object
    name: cstring
    ver: cstring
    hash: cstring
    arch: uint32
    platform: uint32
    license: cstring
    rel: int64
    desc: cstring
    kind: uint32
    build_sys: uint32
    options: pointer
    env: pointer
    tasks: pointer