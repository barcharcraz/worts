#
# Script.ps1
#

#version providers
function Get-GitHubVersion {
    param(
        [string]$reponame,
        [string]$vermatcher = '(\d+)\.(\d+)\.(\d+)'
    )
    $result_json = Invoke-WebRequest -Uri "https://api.github.com/repos/$reponame/releases" -Method Get
    $release_info = ConvertFrom-Json -InputObject "$result_json"
    $release_info = Sort-Object -InputObject $release_info -Property published_at
    $latest = $release_info[0]
    $latest.tag_name -match $vermatcher > $null
    [version]($matches[0])
    

}

function Get-WortDefaults {
    param(
        [string]$base = $WortConfig.Base,
        [string]$name = $pkg_name,
        [string]$version = $pkg_ver,
        [string]$varient = $pkg_varient
    )
    $postfix = "$name/$version-$varient"
    $Global:pkg_name = $name
    $Global:pkg_ver = $version
    $Global:download_dir = "$base/download"
    $Global:src_dir = "$base/source/$postfix"
    $Global:build_dir = "$base/build/$postfix"
    $Global:install_dir = "$base/pkgs/$postfix"


}


# ---- default scripts -----
function Wort-DefaultInitialize {
    function Global:initialize {
        New-Item -ItemType Directory -Path $Global:download_dir -Force
        New-Item -ItemType Directory -Path $Global:src_dir -Force
        New-Item -ItemType Directory -Path $Global:build_dir -Force
        New-Item -ItemType Directory -Path $Global:install_dir -Force
    }
}
function Wort-MultiVersion {
    param(
        $verInfo
    )
    $verInfo.GetEnumerator() | ForEach-Object {
        New-Item -Force Variable:$($_.Name) -Value $_.Value
    }
}
function Wort-DefaultDownload {
    $extension = [IO.Path]::GetExtension($url)
    $Global:download = $(Join-Path $download_dir "$pkg_name-$pkg_ver-$pkg_varient$extension")
    function Global:download {
        Invoke-WebRequest $url -OutFile $download
        if((Get-FileHash -Algorithm SHA256 $Global:download).Hash -ne $Global:hash.ToUpper()) {
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
        if(Get-Command bsdtar -ErrorAction SilentlyContinue) {
            Write-Information "Extracting with bsdtar"
            bsdtar -C $src_dir -xf $download 
        } elseif (Get-Command Expand-Archive -ErrorAction SilentlyContinue) {
            Write-Information "Extracting with Expand-Archive"
            Expand-Archive -Path $download -DestinationPath $src_dir
        } else {
            Write-Error "No extraction method found"
        }
        $children = Get-ChildItem -Force $src_dir
        Write-Information $children
        if($children.Length -eq 1) {
            Write-Output "Moving Files from single subdirectory"
            $dirname = $children[0].FullName
            #Write-Output "$src_dir/$dirname/*"
            Write-Debug $dirname
            Get-ChildItem -Recurse -Force $dirname | Move-Item -Destination $src_dir
            #Move-Item -Force "$src_dir/$dirname/.*" $src_dir
            Remove-Item $children[0].FullName
        }
    }

}

function Wort-CMakeVSBuild {
    function Global:build {
        msbuild $build_dir/ALL_BUILD.vcxproj /p:Configuration=RelWithDebInfo
    }
}
function Wort-CMakeVSInstall {
    function Global:install {
        msbuild $build_dir/INSTALL.vcxproj /p:Configuration=RelWithDebInfo
    }
}

function Wort-CMakeDefaultPrepare {
    function Global:prepare {
        Push-Location $build_dir
        cmake -G Ninja -DCMAKE_BUILD_TYPE=RelWithDebInfo `
                       -DCMAKE_INSTALL_PREFIX="$install_dir" `
                       $src_dir
        Pop-Location
    }
}
function Wort-CMakeDefaultBuild {
    function Global:build {
        ninja -C $build_dir
    }
}
function Wort-CMakeDefaultInstall {
    function Global:install {
        ninja -C $build_dir install
    }
}
function Wort-CMakeDefault {
    Wort-DefaultInitialize

    Wort-DefaultDownload

    Wort-DefaultExtract

    Wort-CMakeDefaultPrepare

    Wort-CMakeDefaultBuild

    Wort-CMakeDefaultInstall
    
}

