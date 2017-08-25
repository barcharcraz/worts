

proc back*[T](s: seq[T]): var T =
    result = s[^1]