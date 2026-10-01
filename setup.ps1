[CmdletBinding(DefaultParameterSetName = 'Help')]
param(
  [Parameter(ParameterSetName = 'Home', Mandatory)][switch]$CopyHome,
  [Parameter(ParameterSetName = 'Install', Mandatory)][switch]$Install,
  [Parameter(ParameterSetName = 'Init', Mandatory)][switch]$Init,
  [Parameter(ParameterSetName = 'Plan', Mandatory)][switch]$Plan,
  [switch]$Extras,
  [string]$HomeDirectory = $HOME,
  [string]$ProfilePath
)
#requires -Version 7.0
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
$profileRoot = Join-Path $PSScriptRoot 'profile'
$script:backupDirectory = $null
$HomeDirectory = [IO.Path]::GetFullPath($HomeDirectory)
if (-not $ProfilePath) {
  $ProfilePath = if ($HomeDirectory -eq $HOME) { $PROFILE.CurrentUserCurrentHost } else { Join-Path $HomeDirectory 'Documents/PowerShell/Microsoft.PowerShell_profile.ps1' }
}

function Backup-File([string]$Path, [string]$Relative) {
  if (Get-Item -LiteralPath $Path -Force -ErrorAction SilentlyContinue) {
    if (-not $script:backupDirectory) {
      $script:backupDirectory = Join-Path $HomeDirectory ('.profile-backups/' + (Get-Date -Format 'yyyyMMdd-HHmmss') + '-' + [guid]::NewGuid().ToString('N'))
      Write-Host "Backups: $script:backupDirectory"
    }
    $backupPath = Join-Path $script:backupDirectory $Relative
    New-Item -ItemType Directory -Path (Split-Path $backupPath) -Force | Out-Null
    $item = Get-Item -LiteralPath $Path -Force
    if ($item.LinkType -and -not $item.PSIsContainer -and (Test-Path -LiteralPath $Path)) {
      [IO.File]::Copy($Path, $backupPath)
      Remove-Item -LiteralPath $Path
    } else {
      Move-Item -LiteralPath $Path -Destination $backupPath
    }
  }
}

function Ensure-Directory([string]$Path) {
  $item = Get-Item -LiteralPath $Path -Force -ErrorAction SilentlyContinue
  $parent = Split-Path $Path
  if ($parent -and $parent -ne $Path) { Ensure-Directory $parent }
  if ($item -and $item.PSIsContainer -and -not $item.LinkType) { return }
  # Refuse directory links rather than writing through them into another tree.
  if ($item -and $item.LinkType -and $item.PSIsContainer) {
    throw "Directory is a link: $Path. Replace it with a real directory before setup."
  }
  if ($item) { Backup-File $Path ('directories/' + [guid]::NewGuid().ToString('N')) }
  New-Item -ItemType Directory -Path $Path -Force | Out-Null
}

function Copy-ManagedFile([string]$Source, [string]$Destination, [string]$Relative) {
  Ensure-Directory (Split-Path $Destination)
  $item = Get-Item -LiteralPath $Destination -Force -ErrorAction SilentlyContinue
  if ($item -and -not $item.PSIsContainer -and -not $item.LinkType -and
      (Get-FileHash -LiteralPath $Source).Hash -eq (Get-FileHash -LiteralPath $Destination).Hash) { return }
  Backup-File $Destination $Relative
  Copy-Item -LiteralPath $Source -Destination $Destination
  Write-Host "Copied $Destination"
}

function Install-GitConfig {
  $defaults = '~/.config/git/profile.gitconfig'
  Copy-ManagedFile (Join-Path $profileRoot 'Windows/home/.gitconfig') (Join-Path $HomeDirectory '.config/git/profile.gitconfig') '.config/git/profile.gitconfig'
  $target = Join-Path $HomeDirectory '.gitconfig'
  $item = Get-Item -LiteralPath $target -Force -ErrorAction SilentlyContinue
  $oldContent = if (Test-Path -LiteralPath $target -PathType Leaf) { [IO.File]::ReadAllText($target) } else { '' }
  if ($item -and -not $item.LinkType -and $oldContent.Contains("    path = $defaults")) { return }
  if ($item -and $item.PSIsContainer) { throw "$target must be a file" }
  $temporary = Join-Path ([IO.Path]::GetTempPath()) ([guid]::NewGuid().ToString('N') + '.gitconfig')
  try {
    [IO.File]::WriteAllText($temporary, "[include]`n    path = $defaults`n" + $oldContent)
    Copy-ManagedFile $temporary $target '.gitconfig'
  } finally { Remove-Item -LiteralPath $temporary -ErrorAction SilentlyContinue }
}

function Install-Home {
  Install-GitConfig
  Copy-ManagedFile (Join-Path $profileRoot 'Windows/home/.profile.ps1') $ProfilePath 'PowerShell/profile.ps1'
  $nvimDirectory = if ($HomeDirectory -eq $HOME -and $env:LOCALAPPDATA) { Join-Path $env:LOCALAPPDATA 'nvim' } else { Join-Path $HomeDirectory 'AppData/Local/nvim' }
  Ensure-Directory $nvimDirectory
  Backup-File (Join-Path $nvimDirectory 'init.vim') 'nvim/init.vim'
  Copy-ManagedFile (Join-Path $profileRoot 'Common/home/.config/nvim/init.lua') (Join-Path $nvimDirectory 'init.lua') 'nvim/init.lua'
}

function Install-Tools {
  $scripts = @(Join-Path $profileRoot 'Windows/init/apps.ps1')
  if ($Extras) { $scripts += Join-Path $profileRoot 'Windows/extras/modules.ps1' }
  foreach ($scriptPath in $scripts) {
    Write-Host "Running $scriptPath"
    & (Join-Path $PSHOME 'pwsh.exe') -NoProfile -NonInteractive -File $scriptPath
    if ($LASTEXITCODE -ne 0) { throw "Failed ($LASTEXITCODE): $scriptPath" }
  }
}

if ($Plan) {
  Write-Output 'Core: Git, Neovim, mise; PowerShell 7 and Windows curl are prerequisites.'
  Write-Output 'Copies: Git defaults, PowerShell profile, Neovim config. Existing files are backed up.'
  if ($Extras) { Write-Output 'Extras: posh-git, ZLocation (CurrentUser modules).' }
} elseif ($Install) {
  Install-Tools
  Install-Home
} elseif ($CopyHome) {
  Install-Home
} elseif ($Init) {
  Install-Tools
} else {
  Write-Output 'Usage: ./setup.ps1 -Install | -CopyHome | -Init | -Plan [-Extras]'
}
