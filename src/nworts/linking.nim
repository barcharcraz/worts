import os
import logging

proc link_directory*(src, dst: string) =
    for path in walkDirRec(src):
        