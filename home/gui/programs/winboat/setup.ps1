Set-ExecutionPolicy -ExecutionPolicy Unrestricted # hold my beer

#region functions
function Update-RegistryValues {
  param (
    [hashtable]$registryTweaks
  )

  foreach ($path in $registryTweaks.Keys) {
    if (!(Test-Path $path)) {
      New-Item -Path $path -Force | Out-Null
    }
    foreach ($name in $registryTweaks[$path].Keys) {
      Set-ItemProperty -Path $path -Name $name -Value $registryTweaks[$path][$name] -Type DWord -Force
      Write-Host "Set $path\$name to $($registryTweaks[$path][$name])"
    }
  }
  taskkill.exe /F /IM "explorer.exe"
  Start-Process "explorer.exe"
}

function Disable-Services {
  param (
    [string[]]$serviceNames
  )

  foreach ($service in $serviceNames) {
    $svc = Get-Service -Name $service -ErrorAction SilentlyContinue
    if ($svc) {
      Stop-Service -Name $service -Force
      Set-Service -Name $service -StartupType Disabled
      Write-Host "Disabled service: $service"
    } else {
      Write-Host "Service not found: $service"
    }
  }
}

function Add-NetworkStorage {
  param (
    [string]$networkPath,
    [string]$driveLetter,
    [bool]$runAtStartup = $true
  )

  if (!(Test-Path $driveLetter) -and (Test-Path $networkPath)) {
    net use $driveLetter $networkPath /persistent:yes

    if ($LASTEXITCODE -eq 0) {
      Write-Host "Mapped $networkPath to $driveLetter"
    } else {
      Write-Host "Failed to map $networkPath to $driveLetter"
    }
  } else {
    Write-Host "$driveLetter is already mapped"
  }

  if ($runAtStartup) {
    $batContent = @"
@echo off
net use $driveLetter $networkPath /persistent:yes
"@
    $startupFolder = [Environment]::GetFolderPath('Startup')
    $batPath = Join-Path $startupFolder "MapNetworkDrive.bat"
    if (!(Test-Path $batPath)) {
      Set-Content -Path $batPath -Value $batContent -Force
      Write-Host "Created startup script at $batPath"
    } else {
      Write-Host "Startup script already exists at $batPath"
    }
  }
}

function Ensure-WinGetSourceExists {
  $expectedSource = "https://cdn.winget.microsoft.com/cache"
  $currentSource = (winget source list | Select-String -Pattern "^winget\s+" | ForEach-Object { $_.Line -split '\s+' })[1]

  if ($currentSource -ne $expectedSource) {
    winget source remove winget
    winget source add winget $expectedSource
    winget source update
    Write-Host "Updated winget source to $expectedSource"
  }
}

function Install-WinGetPackages {
  Ensure-WinGetSourceExists

  winget install --id=Microsoft.DotNet.Framework.DeveloperPack_4 -v "4.6.2" -e --accept-package-agreements
  winget install --id=Microsoft.DotNet.SDK.8 -e --accept-package-agreements
  winget install --id=Microsoft.DotNet.SDK.9 -e --accept-package-agreements
  winget install --id=Microsoft.Git -e --accept-package-agreements
  winget install --id=CoreyButler.NVMforWindows -e --accept-package-agreements

  winget install --id=Microsoft.Edge -e --accept-package-agreements
  winget install --id=Microsoft.VisualStudioCode --scope machine -e --accept-package-agreements
  winget install --id=Microsoft.VisualStudio.Community -e --accept-package-agreements
  winget install --id=Microsoft.Azure.StorageExplorer -e --accept-package-agreements
  winget install --id=Microsoft.PowerBI -e --accept-package-agreements
  winget install --id=Microsoft.SQLServerManagementStudio -e --accept-package-agreements
  winget install --id=MscrmTools.XrmToolBox -e --accept-package-agreements

  winget install --id=Giorgiotani.Peazip -e --accept-package-agreements
  winget install --id=Microsoft.Office -e --accept-package-agreements
  winget install --id=Rufus.Rufus -e --accept-package-agreements
}

function Install-VSCodeExtension {
  param (
    [string[]]$extensionIds
  )

  foreach ($ext in $extensionIds) {
    code --install-extension $ext --force
    Write-Host "Installed VSCode extension: $ext"
  }
}

function Install-DevDependencies {
  # install microsoft/artifacts-credprovider @ https://github.com/Microsoft/artifacts-credprovider
  iex "& { $(irm https://aka.ms/install-artifacts-credprovider.ps1) }"

  # install Power Platform CLI
  dotnet tool install --global Microsoft.PowerApps.CLI.Tool

  # install latest LTS Node.js via nvm
  nvm install lts
  nvm on

  # install global npm packages
  npm install -g @microsoft/rush
  npm install -g pnpm
}
#endregion functions

Update-RegistryValues @{
  "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" = @{
    "DisableWindowsConsumerFeatures" = 1
  }
  "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" = @{
    "AllowTelemetry" = 0
    "DoNotShowFeedbackNotifications" = 1
  }
  "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" = @{
    "AllowTelemetry" = 0
  }
  "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" = @{
    "TurnOffWindowsCopilot" = 1
  }
  "HKCU:\Software\Policies\Microsoft\Windows\WindowsCopilot" = @{
    "TurnOffWindowsCopilot" = 1
  }
  "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" = @{
    "ShowCopilotButton" = 0
    "ShowTaskViewButton" = 0
    "Hidden" = 1
    "HideFileExt" = 0
  }
  "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" = @{
    "BingSearchEnabled" = 0
    "SearchboxTaskbarMode" = 0
  }
  "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" = @{
    "EnableActivityFeed" = 0
    "PublishUserActivities" = 0
    "UploadUserActivities" = 0
  }
  "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" = @{
    "LongPathsEnabled" = 1
  }
  "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" = @{
    "AppsUseLightTheme" = 0
    "SystemUsesLightTheme" = 0
  }
  "HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device\Start" = @{
    "HideRecommendedSection" = 1
  }
  "HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device\Education" = @{
    "IsEducationEnvironment" = 1
  }
  "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" = @{
    "HideRecommendedSection" = 1
  }
  "HKLM:\SOFTWARE\CurrentControlSet\Control\CrashControl" = @{
    "DisplayParameters" = 1
    "DisableEmoticon" = 1
  }
}

Disable-Services -serviceNames @(
  "DiagTrack",
  "dmwappushservice"
)

Add-NetworkStorage -networkPath "\\host.lan\Data" -driveLetter "Z:"

Install-WinGetPackages

Install-VSCodeExtension -extensionIds @(
  "github.copilot",
  "github.copilot-chat",
  "eamodio.gitlens",
  "editorconfig.editorconfig",
  "yzhang.markdown-all-in-one",
  "heaths.vscode-guid",
  "ms-dotnettools.csdevkit",
  "ms-vscode.vscode-node-azure-pack",
  "networg.talxis-sdk-devkit-vscode",
  "heaths.vscode-guid",
  "streetsidesoftware.code-spell-checker",
  "streetsidesoftware.code-spell-checker-czech",
  "azurite.azurite"
)

Install-DevDependencies