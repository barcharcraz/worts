overview
===========

These are the docs for the nim version of worts and
the associated libraries and utilities

the idea is that ports are written as nakefiles and then
built and installed much like a "real" bsd port. Since they
are written in nim you compile them to executables and the target
does not need much of a runtime.

A secondary goal is to understand build systems enough to keep track of what options
are available for a given package and which ones were selected. This inforamtion
is used to make package development easier