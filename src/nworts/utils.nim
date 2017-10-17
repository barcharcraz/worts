

proc back*[T](s: var seq[T]): var T =
    result = s[^1]
