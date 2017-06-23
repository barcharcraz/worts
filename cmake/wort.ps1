$versions = @{
    "3.9.0-rc4" = {
        $url = "https://cmake.org/files/v3.9/cmake-3.9.0-rc4.tar.Z"
        $hash = "72339973d0d905b0970d0687b9b0b789459c1528207569db2e4b75230cfe7808"
        $sig = "https://cmake.org/files/v3.9/cmake-3.9.0-rc4-SHA-256.txt.asc"
    }
    "3.6.1" = {
        $url ="https://cmake.org/files/v3.6/cmake-3.6.1.zip"
        $hash = "6d94468051389fcf0495c7a7acf0bfd9147895a8cf3af7b695a1509764d02679"
    }
}

Get-WortDefaults $base "cmake" "3.9.0-rc4"
. $versions.$pkg_ver
Wort-CmakeDefault