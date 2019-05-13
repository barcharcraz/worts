$ModuleManifestName = 'worts.psd1'
$ModuleManifestPath = "$PSScriptRoot\..\$ModuleManifestName"

Describe 'Module Manifest Tests' {
    It 'Passes Test-ModuleManifest' {
        Test-ModuleManifest -Path $ModuleManifestPath | Should Not BeNullOrEmpty
        $? | Should Be $true
    }
}

Describe 'Bahavior Use Tests' {
    Import-Module -Force $ModuleManifestPath
    It 'injects variables as import' {
        Initialize-WortPackage -Name "test"  -Version "1" -As Import
        "Variable:base" | Should -Exist
        "Variable:download_dir" | Should -Exist
        "Variable:build_dir" | Should -Exist
        $version | Should -Be 1.0.0
        $name | Should -Be test
    }
    It 'Returns an object as object' {
        $o = Initialize-WortPackage -Name test -Version 1.2.3 -As Object
        $o.base | Should -Not -BeNullOrEmpty
        $o.name | Should -Not -BeNullOrEmpty
    }
    It 'Returns a module as module' {
        $m = Initialize-WortPackage -Name test -Version 1.2.3 -As Module
        Import-Module $m
        "Variable:base" | Should -Exist
        "Variable:download_dir" | Should -Exist
        "Variable:build_dir" | Should -Exist
    }
}