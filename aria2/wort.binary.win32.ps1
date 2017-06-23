$versions = @{
    "1.32.0" = {
        $url = "https://github.com/aria2/aria2/releases/download/release-1.32.0/aria2-1.32.0-win-64bit-build1.zip"
        $hash = "d42f733f18e400bbb7684feeec0f3a487ee73d248435404b4215166513ecb693"
    }
    "1.26.0" = {
        $url = "https://github.com/aria2/aria2/releases/download/release-1.26.0/aria2-1.26.0-win-64bit-build1.zip"
        $hash = "AE6070C5009D4964BA87863C23F8627A9E13C586941054B75B593D3C160AED5A"
    }
}

. "$(Split-Path -parent $PSCommandPath)/wort.binary.ps1"

