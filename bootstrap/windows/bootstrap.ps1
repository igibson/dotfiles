param(
    [ValidateSet("work", "home", "windows")]
    [string]$Profile = "home"
)

Write-Host "Running Windows bootstrap with profile: $Profile"

# --- Step 0: Ensure execution policy allows scripts ---
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# --- Step 1: Install WinGet packages ---
Write-Host "Installing base apps via WinGet..."
$wingetPath = Join-Path $PSScriptRoot "winget.yaml"
if (Test-Path $wingetPath) {
    winget import $wingetPath --accept-package-agreements --accept-source-agreements
} else {
    Write-Warning "winget.yaml not found at $wingetPath"
}

# --- Step 2: Install Scoop if missing ---
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Scoop..."
    iwr -useb get.scoop.sh | iex
} else {
    Write-Host "Scoop already installed, skipping."
}

.\scoop-install.ps1


# --- Step 4: Install Rust and Cargo tools ---
if (-not (Get-Command cargo -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Rust..."
    winget install Rustlang.Rustup --accept-package-agreements --accept-source-agreements
} else {
    Write-Host "Rust already installed, skipping."
}

# Ensure Cargo bin directory is in PATH
$env:CARGO_HOME = "$env:USERPROFILE\.cargo"
$env:PATH += ";$env:CARGO_HOME\bin"


# Install Rust CLI tools
$rustTools = @("dotter")
foreach ($tool in $rustTools) {
    if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) {
        Write-Host "Installing $tool via Cargo..."
        cargo install $tool --locked
    } else {
        Write-Host "$tool already installed, skipping."
    }
}

Write-Host "Bootstrap complete!"
