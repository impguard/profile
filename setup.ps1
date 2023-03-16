Param(
  [Parameter(ParameterSetName = "Home")]
  [switch]$HomeParam

  [Parameter(ParameterSetName = "Install")]
  [switch]$InstallParam
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

function Stage {
  New-Item -ItemType SymbolicLink `
    -Path "./staging/home/.gitconfig" `
    -Target "./profile/Common/home/.gitconfig"
}

########################################
# Commands
########################################

function Install {
  Home
}

function Home {
  Log "Linking home files"

  $Source = $PROFILE_DIR.Replace("\", "\\")
  $Items = Get-ChildItem -LiteralPath "./staging/home" -Recurse

  Write-Host $Items
}

if ($HomeParam) {
  Stage
  Home
}
else if ($InstallParam) {
  Stage
  Install
}
else {
  Get-Help $MyInvocation.MyCommand.Definition
}

