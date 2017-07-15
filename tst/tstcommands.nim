import nworts.commands
import os

command "args":
    echo paramCount()
    for i in 0..paramCount():
        echo paramStr(i)

call_command("args")