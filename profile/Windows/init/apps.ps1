$ErrorActionPreference = 'Stop'
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) { throw 'Install App Installer (winget) first.' }
foreach ($tool in @(@{ Command = 'git'; Id = 'Git.Git' }, @{ Command = 'nvim'; Id = 'Neovim.Neovim' }, @{ Command = 'mise'; Id = 'jdx.mise' })) {
  $existing = Get-Command $tool.Command -ErrorAction SilentlyContinue
  if (-not $existing) {
    Write-Host "Installing $($tool.Id) with winget..."
    & winget install --exact --id $tool.Id --source winget --silent --accept-source-agreements --accept-package-agreements
    if ($LASTEXITCODE -ne 0) { throw "winget failed ($LASTEXITCODE): $($tool.Id)" }
    Write-Host "Installed: $($tool.Id)"
  } else {
    Write-Host "Skipped (already available): $($tool.Id) [$($existing.Source)]"
  }
}
