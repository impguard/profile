$ErrorActionPreference = 'Stop'
foreach ($module in 'posh-git', 'ZLocation') {
  if (-not (Get-Module -ListAvailable $module)) {
    Write-Host "Installing PowerShell module $module for the current user..."
    Install-Module -Name $module -Scope CurrentUser -Repository PSGallery -Force
    Write-Host "Installed module: $module"
  } else {
    Write-Host "Skipped (already installed): $module"
  }
}
