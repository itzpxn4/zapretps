#requires -RunAsAdministrator

param (
    [switch]$folder,
    [switch]$list,
    [switch]$config,
    [switch]$Help
)

$basePath = "C:\PLACE\YOUR\PATH\HERE\zapret-discord-youtube-1.9.8b"
$listPath = "$basePath\lists\list-general.txt"
$strategy = "general (ALT3).bat"
$scriptPath = $MyInvocation.MyCommand.Path

if ($Help) {
    @"
-help    : Этот список
-folder  : Папка запрета
-list    : Список сайтов
-config  : Скрипт
"@
    exit
}

if ($config) { ii $scriptPath; Write-Host "Config opened." -ForegroundColor Green; exit }
if ($folder) { ii $basePath; Write-Host "Folder opened." -ForegroundColor Green; exit }
if ($list) { ii $listPath; Write-Host "List opened." -ForegroundColor Green; exit }

if (-not (Get-Module -ListAvailable -Name VirtualDesktop)) {
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Install-Module -Name VirtualDesktop -Scope CurrentUser -Force -Confirm:$false > $null
        Import-Module VirtualDesktop -DisableNameChecking
    } catch { exit }
} else {
    Import-Module VirtualDesktop -DisableNameChecking
}

Start-Process "$basePath\$strategy" -Verb RunAs -WindowStyle Hidden

Start-Sleep -Seconds 1

$winwsProcesses = Get-Process "winws" -ErrorAction SilentlyContinue

if ($winwsProcesses) {
    foreach ($proc in $winwsProcesses) {
        if ($proc.MainWindowHandle -ne 0) {
            try {
                $target = Get-Desktop -Index 1 
                [void]($proc.MainWindowHandle | Move-Window -Desktop $target)
                Write-Host "Fine." -ForegroundColor Green
            } catch {}
        }
    }
}
