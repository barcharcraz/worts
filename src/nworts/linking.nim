import os
import logging

proc link_directory*(src, dst: string) =
    for path in walkDirRec(src):
        var relpath = path[src.len..^1]
        if symlinkExists(src / relpath):
            error("Symlink exists")
            raise newException(IOError, "Symlink did not exist")
        createSymlink(path, src / relpath)
        
            