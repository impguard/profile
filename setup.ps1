[CmdletBinding(DefaultParameterSetName = 'Help')]
param(
  [Parameter(ParameterSetName = 'Help')][Alias('h')][switch]$Help,
  [Parameter(ParameterSetName = 'List')][Alias('ls')][switch]$List,
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

function Show-Profiles {
  $windowsRoot = Join-Path $profileRoot 'Windows'
  $homeFiles = (Get-ChildItem -LiteralPath (Join-Path $windowsRoot 'home') -File -Force).Name -join ', '
  $initScripts = (Get-ChildItem -LiteralPath (Join-Path $windowsRoot 'init') -Filter '*.ps1' -File).Name -join ', '
  $extraScripts = (Get-ChildItem -LiteralPath (Join-Path $windowsRoot 'extras') -Filter '*.ps1' -File).Name -join ', '
  Write-Output 'Profile      : Windows'
  Write-Output 'For          : Windows (PowerShell 7) - base tools and configuration'
  Write-Output "Home files   : $homeFiles, nvim/init.lua (shared)"
  Write-Output "Init scripts : $initScripts (Git, Neovim, mise)"
  Write-Output "Extras       : $extraScripts (posh-git, zoxide; use -Extras)"
}

function Show-Usage {
  Show-Profiles
  Write-Output @'

Usage:
  ./setup.ps1 -Install [-Extras]   Install tools and home configuration
  ./setup.ps1 -CopyHome            Copy home configuration only
  ./setup.ps1 -Init [-Extras]      Install tools only
  ./setup.ps1 -Plan [-Extras]      Preview tools and destination paths
  ./setup.ps1 -List                List the Windows profile and scripts
  ./setup.ps1 -Help                Show this summary (also the default)
'@
}

if ($PSCmdlet.ParameterSetName -eq 'Help') {
  Show-Usage
  return
}
if ($List) {
  Show-Profiles
  return
}
$script:backupDirectory = $null
$script:copiedCount = 0
$script:unchangedCount = 0
$script:backupCount = 0
$HomeDirectory = [IO.Path]::GetFullPath($HomeDirectory)
if (-not $ProfilePath) {
  $ProfilePath = if ($HomeDirectory -eq $HOME) { $PROFILE.CurrentUserCurrentHost } else { Join-Path $HomeDirectory 'Documents/PowerShell/Microsoft.PowerShell_profile.ps1' }
}
$nvimDirectory = if ($HomeDirectory -eq $HOME -and $env:LOCALAPPDATA) { Join-Path $env:LOCALAPPDATA 'nvim' } else { Join-Path $HomeDirectory 'AppData/Local/nvim' }

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
    $script:backupCount++
    Write-Host "Backed up: $Path -> $backupPath"
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
      (Get-FileHash -LiteralPath $Source).Hash -eq (Get-FileHash -LiteralPath $Destination).Hash) {
    $script:unchangedCount++
    Write-Host "Skipped (unchanged): $Destination"
    return
  }
  Backup-File $Destination $Relative
  Copy-Item -LiteralPath $Source -Destination $Destination
  $script:copiedCount++
  Write-Host "Copied: $Destination"
}

function Install-GitConfig {
  $defaults = '~/.config/git/profile.gitconfig'
  Copy-ManagedFile (Join-Path $profileRoot 'Windows/home/.gitconfig') (Join-Path $HomeDirectory '.config/git/profile.gitconfig') '.config/git/profile.gitconfig'
  $target = Join-Path $HomeDirectory '.gitconfig'
  $item = Get-Item -LiteralPath $target -Force -ErrorAction SilentlyContinue
  $oldContent = if (Test-Path -LiteralPath $target -PathType Leaf) { [IO.File]::ReadAllText($target) } else { '' }
  if ($item -and -not $item.LinkType -and $oldContent.Contains("    path = $defaults")) {
    $script:unchangedCount++
    Write-Host "Skipped (defaults already included): $target"
    return
  }
  if ($item -and $item.PSIsContainer) { throw "$target must be a file" }
  $temporary = Join-Path ([IO.Path]::GetTempPath()) ([guid]::NewGuid().ToString('N') + '.gitconfig')
  try {
    [IO.File]::WriteAllText($temporary, "[include]`n    path = $defaults`n" + $oldContent)
    Copy-ManagedFile $temporary $target '.gitconfig'
  } finally { Remove-Item -LiteralPath $temporary -ErrorAction SilentlyContinue }
}

function Install-Home {
  Write-Host "`n[Home] Installing Git, PowerShell, and Neovim configuration" -ForegroundColor Cyan
  Write-Host "Home directory: $HomeDirectory"
  Install-GitConfig
  Copy-ManagedFile (Join-Path $profileRoot 'Windows/home/.profile.ps1') $ProfilePath 'PowerShell/profile.ps1'
  Ensure-Directory $nvimDirectory
  Backup-File (Join-Path $nvimDirectory 'init.vim') 'nvim/init.vim'
  Copy-ManagedFile (Join-Path $profileRoot 'Common/home/.config/nvim/init.lua') (Join-Path $nvimDirectory 'init.lua') 'nvim/init.lua'
}

function Install-Tools {
  Write-Host "`n[Tools] Checking Git, Neovim, and mise" -ForegroundColor Cyan
  if ($Extras) { Write-Host 'Optional extras: posh-git, zoxide' }
  $scripts = @(Join-Path $profileRoot 'Windows/init/apps.ps1')
  if ($Extras) { $scripts += Join-Path $profileRoot 'Windows/extras/tools.ps1' }
  foreach ($scriptPath in $scripts) {
    Write-Host "Running: $scriptPath"
    & (Join-Path $PSHOME 'pwsh.exe') -NoProfile -NonInteractive -File $scriptPath
    if ($LASTEXITCODE -ne 0) { throw "Failed ($LASTEXITCODE): $scriptPath" }
    Write-Host "Completed: $(Split-Path $scriptPath -Leaf)"
  }
}

if ($Plan) {
  Write-Output 'Windows setup preview (no changes will be made)'
  Write-Output 'Core: Git, Neovim, mise; PowerShell 7 and Windows curl are prerequisites.'
  Write-Output 'Copies: Git defaults, PowerShell profile, Neovim config. Existing files are backed up.'
  Write-Output "Home directory: $HomeDirectory"
  Write-Output "PowerShell profile: $ProfilePath"
  Write-Output "Neovim config: $(Join-Path $nvimDirectory 'init.lua')"
  Write-Output "Backup directory: $(Join-Path $HomeDirectory '.profile-backups') (created only when needed)"
  if ($Extras) { Write-Output 'Extras: posh-git (CurrentUser module), zoxide (winget).' }
} elseif ($Install) {
  Install-Tools
  Install-Home
} elseif ($CopyHome) {
  Install-Home
} elseif ($Init) {
  Install-Tools
} else {
  Show-Usage
}

if ($Install -or $CopyHome -or $Init) {
  Write-Host "`nSetup completed." -ForegroundColor Green
  if ($Install -or $CopyHome) {
    Write-Host "Configuration files copied: $script:copiedCount; unchanged: $script:unchangedCount; entries backed up: $script:backupCount"
    if ($script:backupDirectory) { Write-Host "Recover previous settings from: $script:backupDirectory" }
  }
  Write-Host 'Open a new PowerShell session to load updated tools and profile settings.'
}
