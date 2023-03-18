[CmdletBinding(DefaultParameterSetName = "Help")]
Param(
  [Parameter(ParameterSetName = "Home")]
  [switch]$CopyHome,
  [Parameter(ParameterSetName = "Install")]
  [switch]$Install,
  [Parameter(ParameterSetName = "Init")]
  [switch]$Init
)

$ROOT = "$HOME\.profile.d"
$PROFILE_DIR = "$ROOT\profile"
$STAGING_DIR = "$ROOT\staging"
$INSTALL_DIR = "$ROOT\staging\install"

########################################
# Helpers
########################################

function Log {
  Write-Host $args -ForegroundColor Green
}

function LinkFiles {
  Param(
    [Parameter()]
    [string]$Target,
    [Parameter()]
    [string]$Destination
  )

  New-Item -ItemType Directory -Path "$Destination" -Force | Out-Null
  $Files = Get-ChildItem -Path "$Target" -Name -Recurse
  foreach ($File in $Files) {
    Write-Host $File
    New-Item -ItemType SymbolicLink `
      -Path "$Destination\$File" `
      -Target "$Target\$File" -Force
  }
}

function Stage {
  LinkFiles -Target "$PROFILE_DIR\Windows\home" -Destination "$STAGING_DIR\home"
  LinkFiles -Target "$PROFILE_DIR\Windows\init" -Destination "$STAGING_DIR\init"
}

########################################
# Commands
########################################

function Install {
  Home
  Init
}

function Home {
  Log "Linking home files"
  LinkFiles -Destination "$HOME" -Target "$STAGING_DIR\home"

  New-Item -ItemType SymbolicLink `
    -Path "$PROFILE" `
    -Target "$HOME\.profile.ps1" -Force
}

function Init {
  Log "Running init scripts"
  $Files = Get-ChildItem -LiteralPath "$STAGING_DIR\init" -Recurse
  foreach ($File in $Files) {
    # Need to modify this to use install directory
    & "$STAGING_DIR\init\$File"
  }
}

if ($CopyHome) {
  Stage
  Home
}
elseif ($Install) {
  # Stage
  # Install
}
elseif ($init) {
  # Stage
  # Init
}
else {
  Get-Help $MyInvocation.MyCommand.Definition
}
