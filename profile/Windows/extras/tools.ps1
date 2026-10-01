$ErrorActionPreference = 'Stop'
if (-not (Get-Command zoxide -ErrorAction SilentlyContinue)) {
  if (-not (Get-Command winget -ErrorAction SilentlyContinue)) { throw 'Install App Installer (winget) first.' }
  Write-Host 'Installing ajeetdsouza.zoxide with winget...'
  & winget install --exact --id ajeetdsouza.zoxide --source winget --silent --accept-source-agreements --accept-package-agreements
  if ($LASTEXITCODE -ne 0) { throw "winget failed ($LASTEXITCODE): ajeetdsouza.zoxide" }
  Write-Host 'Installed: zoxide'
} else {
  Write-Host 'Skipped (already available): zoxide'
}
foreach ($module in 'posh-git') {
  if (-not (Get-Module -ListAvailable $module)) {
    Write-Host "Installing PowerShell module $module for the current user..."
    Install-Module -Name $module -Scope CurrentUser -Repository PSGallery -Force
    Write-Host "Installed module: $module"
  } else {
    Write-Host "Skipped (already installed): $module"
  }
}
