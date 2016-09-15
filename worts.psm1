#
# Script.ps1
#
function Clean-All {
    param([string]$base = $(Get-Location))
    Remove-Item -Recurse "$base/install" -Force
    Remove-Item -Recurse "$base/build" -Force
    Remove-Item -Recurse "$base/source" -Force
    Remove-Item -Recurse "$base/download" -Force
    Remove-Item -Recurse "$base/pkgs" -Force
}
function Get-WortDefaults {
    param(
        [string]$base,
        [string]$name,
        [string]$version
    )
    $postfix = "$name\$version"
    $Global:pkg_name = $name
    $Global:pkg_ver = $version
    $Global:download_dir = "$base\download"
    $Global:src_dir = "$base\source\$postfix"
    $Global:build_dir = "$base\build\$postfix"
    $Global:install_dir = "$base\pkgs\$postfix"
    New-Item -ItemType Directory -Path $Global:download_dir -Force
    New-Item -ItemType Directory -Path $Global:src_dir -Force
    New-Item -ItemType Directory -Path $Global:build_dir -Force
    New-Item -ItemType Directory -Path $Global:install_dir -Force
}
function Link-Wort {
    param(
        [string]$pkg,
        [string]$base = $(Get-Location),
        [string]$install_dir = "$base/install"
    )
    New-Item -ItemType Directory "$install_dir" -Force
    Push-Location $(Join-Path "$base/pkgs/" $pkg)
    foreach ($file in $(Get-ChildItem -File -Recurse $(Get-Location))) {
        $relpath = $(Resolve-Path -Relative -Path $file.FullName)
        New-Item -ItemType SymbolicLink -Path $(Join-Path $install_dir $relpath) -Value $file.FullName -Force
    }
    Pop-Location
}

function Unlink-Wort {
    param(
        [string]$pkg,
        [string]$base = $(Get-Location),
        [string]$install_dir = "$base/install"
    )
    Push-Location $(Join-Path "$base/pkgs/" $pkg)
    foreach ($file in $(Get-ChildItem -File -Recurse $(Get-Location))) {
        $relpath = $(Resolve-Path -Relative -Path $file.FullName)
        $linkpath = $(Join-Path $install_dir $relpath)
        $linkitem = $(Get-Item -ErrorAction SilentlyContinue $linkpath)
        if($linkitem -eq $null) {continue}
        if($linkitem.LinkType -eq $null) {
            Write-Warning -Message ("Found non symlink item {0}" -f $linkitem.FullName)
            continue
        }
        if($linkitem.Target -ne $file.FullName) {
            Write-Warning -Message ("Found symlink pointing to another package {0}" -f $linkitem.FullName)
            continue
        }
        Remove-Item $linkitem        
    }
    do {
        $dirs = Get-ChildItem -Directory -Recurse $install_dir |
            Where-Object { (Get-ChildItem $_.FullName).Count -eq 0 } |
            Select-Object -ExpandProperty FullName
        $dirs | ForEach-Object { Remove-Item $_ }
    } while ($dirs.Count -gt 0)
    Pop-Location 
}


# ---- default scripts -----
function Wort-DefaultDownload {
    $extension = [IO.Path]::GetExtension($url)
    $Global:download = $(Join-Path $download_dir "$pkg_name-$pkg_ver$extension")
    function Global:download {
        Invoke-WebRequest $url -OutFile $download
        if((Get-FileHash -Algorithm SHA256 $Global:download).Hash -ne $Global:hash) {
            throw "Error: File {0} failed verification" -f $Global:download
        }
    }
}

function Wort-AriaDownload {
    $extension = [IO.Path]::GetExtension($url)
    $Global:download = $(Join-Path $download_dir "$pkg_name-$pkg_ver$extension")
    function Global:download {
        aria2c --dir=$download_dir --allow-overwrite=true --out=$(Split-Path -Leaf $download) --checksum=$hash -V $url
    }
}

function Wort-DefaultExtract {
    function Global:extract {
        Expand-Archive -Path $download -DestinationPath $src_dir
        $children = Get-ChildItem $src_dir
        Write-Output $children
        if($children.Length -eq 1) {
            Write-Output "Moving Files from single subdirectory"
            $dirname = $children[0].Name
            Write-Output "$src_dir/$dirname/*"
            Move-Item "$src_dir/$dirname/*" $src_dir
            Remove-Item $children[0].FullName
        }
    }

}

function Wort-CMakeVSBuild {
    function Global:build {
        msbuild $build_dir\ALL_BUILD.vcxproj /p:Configuration=RelWithDebInfo
    }
}
function Wort-CMakeVSInstall {
    function Global:install {
        msbuild $build_dir\INSTALL.vcxproj /p:Configuration=RelWithDebInfo
    }
}

function Wort-CMakeDefault {

    Wort-DefaultDownload

    Wort-DefaultExtract

    function Global:prepare {
        Push-Location $build_dir
        cmake -G Ninja -DCMAKE_BUILD_TYPE=RelWithDebInfo `
                       -DCMAKE_INSTALL_PREFIX="$install_dir" `
                       $src_dir
        Pop-Location
    }

    function Global:build {
        ninja -C $build_dir
    }
    function Global:install {
        ninja -C $build_dir install
    }
}

