$ErrorActionPreference = 'Stop'
foreach ($module in 'posh-git', 'ZLocation') {
  if (-not (Get-Module -ListAvailable $module)) {
    Install-Module -Name $module -Scope CurrentUser -Repository PSGallery -Force
  }
}
