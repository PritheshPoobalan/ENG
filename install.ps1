# PowerShell Installation Script for EngLang
# Version 3.1 - Pre-compiled Binary Installer from GitHub

Write-Host "--- EngLang Installer for Windows (Pre-compiled) ---" -ForegroundColor Cyan

# --- Configuration ---
$InstallDirName = "ENG"
$InstallPath = Join-Path -Path $env:USERPROFILE -ChildPath $InstallDirName
$ExecutableName = "eng.exe"
$DownloadUrl = "https://raw.githubusercontent.com/pripro101/ENG/main/bin/eng.exe" # Actual URL for the pre-compiled eng.exe

# --- Script Body ---
Write-Host "Starting EngLang installation..."

# 1. Create Installation Directory
if (-not (Test-Path -Path $InstallPath)) {
    Write-Host "Creating installation directory at: $InstallPath"
    New-Item -ItemType Directory -Path $InstallPath | Out-Null
} else {
    Write-Host "Installation directory already exists: $InstallPath"
}

# 2. Download the pre-compiled executable
$DestinationPath = Join-Path -Path $InstallPath -ChildPath $ExecutableName
Write-Host "Downloading '$ExecutableName' from '$DownloadUrl'..."
try {
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $DestinationPath -ErrorAction Stop
    Write-Host "Download successful." -ForegroundColor Green
} catch {
    Write-Host "Error: Failed to download '$ExecutableName'. Please check the URL and your internet connection." -ForegroundColor Red
    Write-Host "Error details: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# 3. Add Install Directory to User's PATH
Write-Host "Checking user PATH environment variable..."
$UserPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
$PathArray = $UserPath -split ';'
if ($PathArray -contains $InstallPath) {
    Write-Host "'$InstallPath' is already in your PATH." -ForegroundColor Green
} else {
    Write-Host "Adding '$InstallPath' to your user PATH." -ForegroundColor Yellow
    $NewPath = if ([string]::IsNullOrEmpty($UserPath)) { $InstallPath } else { $UserPath + ";" + $InstallPath }
    [System.Environment]::SetEnvironmentVariable("Path", $NewPath, "User")
    Write-Host "PATH updated successfully." -ForegroundColor Green
}

Write-Host "`nInstallation complete!" -ForegroundColor Cyan
Write-Host "----------------------------------------------------------------"
Write-Host "IMPORTANT: You must restart your terminal for the changes to take effect." -ForegroundColor Yellow
Write-Host "After restarting, you can run EngLang scripts from any directory."
