
import os
import logging

type link_desc = tuple
    frm: string
    to: string



proc build_link_list*(fromdir: string, todir: string, links: var seq[link_desc]) =
    for kind, path in walkDir(fromdir):
        var relative = path[len(fromdir)..^1]
        var target = todir / relative
        echo target
        case kind
        of pcFile:
            var (dir, _, _) = splitFile(target)
            if dirExists(dir) and fileExists(target) and sameFile(target, path):
                discard
            elif symlinkExists(target):
                raise newException(IOError, "file " & target & " already exists")
            else:
                links.add((path, target))
        of pcDir:
            build_link_list(path, target, links)
        of pcLinkToDir:
            raise newException(IOError, "Package has symlink")
        of pcLinkToFile:
            raise newException(IOError, "Package has symlink")

proc build_unlink_list*(fromdir: string, todir: string, links: var seq[link_desc]) =
    for kind, path in walkDir(fromdir):
        var relative = path[len(fromdir)..^1]
        var target = todir / relative
        case kind
        of pcFile:
            raise newException(IOError, "there should not be files in the install tree")
        of pcDir:
            build_link_list(path, target, links)
        of pcLinkToDir:
            raise newException(IOError, "Package has symlink")
        of pcLinkToFile:
            if sameFile(target, path):
                links.add((path, target))
            elif symlinkExists(target):
                raise newException(IOError, "file " & target & " does not point to source")
            else:
                doAssert(false)

proc link*(fromdir: string, todir: string) =
    var links: seq[link_desc]
    newSeq(links, 0)
    build_link_list(fromdir, todir, links)
    echo links
    for frm, to in links.items:
        info("created", frm, "==>", to)
        var (dir, _, _) = splitFile(to)
        createDir(dir)
        createSymlink(expandFilename(frm), expandFilename(to))
proc unlink*(fromdir: string, todir: string) =
    var links: seq[link_desc]
    newSeq(links, 0)
    build_unlink_list(fromdir, todir, links)
    for frm, to in links.items:
        info("deleted", to)
        removeFile(to)
    
