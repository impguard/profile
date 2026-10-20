$ErrorActionPreference = 'Stop'
$alreadyInstalled = @(-1978335189, -1978335135) # UPDATE_NOT_APPLICABLE, PACKAGE_ALREADY_INSTALLED
if (-not (Get-Command zoxide -ErrorAction SilentlyContinue)) {
  if (-not (Get-Command winget -ErrorAction SilentlyContinue)) { throw 'Install App Installer (winget) first.' }
  Write-Host 'Installing ajeetdsouza.zoxide with winget...'
  & winget install --exact --id ajeetdsouza.zoxide --source winget --silent --accept-source-agreements --accept-package-agreements
  if ($LASTEXITCODE -eq 0) {
    Write-Host 'Installed: zoxide'
  } elseif ($LASTEXITCODE -in $alreadyInstalled) {
    Write-Host 'Skipped (already installed): ajeetdsouza.zoxide'
  } else {
    throw "winget failed ($LASTEXITCODE): ajeetdsouza.zoxide"
  }
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
