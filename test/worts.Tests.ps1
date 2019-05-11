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
    It 'injects into the correct scope' {
        . Use-DefaultWortVariables -name "test"  -version "1"
        "Variable:base" | Should -Exist
        "Variable:download_dir" | Should -Exist
        "Variable:build_dir" | Should -Exist
    }
    It 'can get variables from caller' {
        $name = "test"
        $ver = "1"
        . Use-DefaultWortVariables
        "Variable:base" | Should -Exist
        "Variable:download_dir" | Should -Exist
    }
}