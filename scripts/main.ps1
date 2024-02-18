﻿$ErrorActionPreference = $env:ErrorAction

Write-Verbose "Importing helper scripts..." -Verbose
Get-ChildItem -Path (Join-Path $env:GITHUB_ACTION_PATH 'scripts' 'helpers') -Filter '*.ps1' -Recurse | ForEach-Object {
    Write-Verbose "[$($_.FullName)]" -Verbose
    . $_.FullName
}

$env:GITHUB_REPOSITORY_NAME = $env:GITHUB_REPOSITORY -replace '.+/', ''

Write-Output '::group::Initializing...'
Write-Output '-------------------------------------------'
$params = @{
    Name        = $env:GITHUB_REPOSITORY_NAME
    Path        = Join-Path $env:GITHUB_WORKSPACE $env:Path
    Verbose     = $env:Verbose -eq 'true'
    WhatIf      = $env:WhatIf -eq 'true'
    ErrorAction = $ErrorActionPreference
}

if (-not [string]::IsNullOrEmpty($env:CustomTestsPath)) {
    $params['CustomTestsPath'] = Join-Path $env:GITHUB_WORKSPACE $env:CustomTestsPath
}

Write-Verbose ($params.GetEnumerator() | Sort-Object -Property Name | Out-String) -Verbose
Write-Output '::endgroup::'

try {
    $failedTests = Test-PSModule @params
} catch {
    Write-Output "::error::$_"
    exit 1
}

# if ($ErrorActionPreference -like '*Continue') {
#     Write-Output '::warning::Errors were ignored.'
#     return
# }
