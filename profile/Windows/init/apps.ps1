$ErrorActionPreference = 'Stop'
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) { throw 'Install App Installer (winget) first.' }
foreach ($tool in @(@{ Command = 'git'; Id = 'Git.Git' }, @{ Command = 'nvim'; Id = 'Neovim.Neovim' }, @{ Command = 'mise'; Id = 'jdx.mise' })) {
  if (-not (Get-Command $tool.Command -ErrorAction SilentlyContinue)) {
    & winget install --exact --id $tool.Id --source winget --silent --accept-source-agreements --accept-package-agreements
    if ($LASTEXITCODE -ne 0) { throw "winget failed ($LASTEXITCODE): $($tool.Id)" }
  }
}
