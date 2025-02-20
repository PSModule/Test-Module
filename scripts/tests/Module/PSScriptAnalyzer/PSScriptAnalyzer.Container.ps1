﻿@{
    Path = Get-ChildItem -Path $PSScriptRoot -Filter *.Tests.ps1 | Select-Object -ExpandProperty FullName
    Data = @{
        Path             = "$env:GITHUB_WORKSPACE/$env:GITHUB_ACTION_INPUT_TEST_PSMODULE_Path"
        SettingsFilePath = "$PSScriptRoot/PSScriptAnalyzer.Settings.psd1"
        Debug            = $false
        Verbose          = $false
    }
}
