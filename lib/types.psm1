class Source {
    [string]$url
    [string]$filename
    [string]$sha256
}
class Configuration {
    [string]$download
    [string]$base
    [string]$install
}
class Package {
    [string]$name
    [semver]$version
    [Source[]]$sources
    [string]PkgBase(
        [Configuration]$conf
    ) { return (Join-Path $conf.base "$($this.name)-$($this.version)") }
    [string]SrcDir([Configuration]$conf) { return (Join-Path $this.PkgBase($conf) "src") }
    [string]BuildDir([Configuration]$conf) { return (Join-Path $this.PkgBase($conf) "build") }
}