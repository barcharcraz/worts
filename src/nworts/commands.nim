## this files implements our personal little clone of nake, with some fancy features
## designed for linking together multiple nakefiles as well as for smarter dependencies
## this is currently not used
import tables
import logging
type CommandNotFoundException* = object of Exception
type DuplicateCommandException* = object of Exception
type Commands* = object
    default_prefix: string
    actions: Table[string, proc()]

proc initCommands(): Commands =
    result.default_prefix = ""
    result.actions = initTable[string, proc()]()

var command_db = initCommands()

proc call_command*(name: string, prefix: string = command_db.default_prefix) =
    var full_name = prefix & "." & name
    if full_name notin command_db.actions:
        raise newException(CommandNotFoundException, "Could not find command: " & full_name)
    command_db.actions[full_name]()

proc add_command*(name: string, command: proc(), prefix: string = command_db.default_prefix) =
    var full_name = prefix & "." & name
    if full_name in command_db.actions:
        raise newException(DuplicateCommandException, "Duplicate command: " & full_name)
    command_db.actions[full_name] = command

proc default_command_prefix*(prefix: string) =
    command_db.default_prefix = prefix

template command*(name: string, body: untyped) =
    add_command(name) do: body

