#requires -Version 7.0
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
$testRoot = Join-Path ([IO.Path]::GetTempPath()) ('profile-tests-' + [guid]::NewGuid().ToString('N'))
$repo = Join-Path $testRoot 'repo with spaces'
$testHome = Join-Path $testRoot 'home with spaces'
$root = Split-Path $PSScriptRoot
function Assert($Condition, [string]$Message) { if (-not $Condition) { throw $Message } }
try {
  New-Item -ItemType Directory -Path $repo, $testHome -Force | Out-Null
  Copy-Item -LiteralPath (Join-Path $root 'setup.ps1') -Destination $repo
  Copy-Item -LiteralPath (Join-Path $root 'profile') -Destination $repo -Recurse
  $setup = Join-Path $repo 'setup.ps1'
  $gitConfig = Join-Path $testHome '.gitconfig'
  [IO.File]::WriteAllText($gitConfig, "[user]`n name = Test User`n email = test@example.com`n[core]`n editor = custom-editor`n")
  $nvim = Join-Path $testHome 'AppData/Local/nvim'
  New-Item -ItemType Directory -Path $nvim -Force | Out-Null
  Set-Content -LiteralPath (Join-Path $nvim 'init.vim') -Value 'old editor'
  Set-Content -LiteralPath (Join-Path $nvim 'keep.txt') -Value 'unrelated'
  & $setup -Plan -HomeDirectory $testHome
  Assert (-not (Test-Path (Join-Path $testHome '.profile-backups'))) 'Plan modified home'
  & $setup -CopyHome -HomeDirectory $testHome
  Assert ((git config --file $gitConfig user.email) -eq 'test@example.com') 'Lost Git identity'
  Assert ((git config --file $gitConfig core.editor) -eq 'custom-editor') 'Lost Git override'
  Assert (Test-Path (Join-Path $nvim 'init.lua')) 'Missing Lua config'
  Assert (-not (Test-Path (Join-Path $nvim 'init.vim'))) 'Old Vim config still active'
  Assert (Test-Path (Join-Path $nvim 'keep.txt')) 'Removed unrelated file'
  $backups = Join-Path $testHome '.profile-backups'
  $before = @(Get-ChildItem -LiteralPath $backups -File -Recurse -Force).Count
  & $setup -CopyHome -HomeDirectory $testHome
  Assert (@(Get-ChildItem -LiteralPath $backups -File -Recurse -Force).Count -eq $before) 'Unchanged files backed up again'
  Assert (@(Select-String -LiteralPath $gitConfig -SimpleMatch 'path = ~/.config/git/profile.gitconfig').Count -eq 1) 'Duplicate Git include'
  Assert (@(Get-ChildItem -LiteralPath $backups -Filter init.vim -Recurse -Force).Count -eq 1) 'Missing legacy editor backup'

  $mock = Join-Path $repo 'profile/Windows/init/apps.ps1'
  Set-Content -LiteralPath $mock -Value "throw 'intentional failure'"
  $caught = $false
  try { & $setup -Init -HomeDirectory $testHome 2> (Join-Path $testRoot 'failure.log') } catch { $caught = $true }
  Assert $caught 'Script failure was swallowed'
  Set-Content -LiteralPath $mock -Value 'exit 23'
  $caught = $false
  try { & $setup -Init -HomeDirectory $testHome } catch { $caught = $_.Exception.Message -like '*Failed (23)*' }
  Assert $caught 'Native exit status was swallowed'
  Write-Host 'PowerShell installer regression tests passed.'
} finally {
  $resolved = [IO.Path]::GetFullPath($testRoot)
  $temp = [IO.Path]::GetFullPath([IO.Path]::GetTempPath())
  if (-not $resolved.StartsWith($temp, [StringComparison]::OrdinalIgnoreCase) -or (Split-Path $resolved -Leaf) -notlike 'profile-tests-*') { throw 'Unsafe test cleanup path' }
  Remove-Item -LiteralPath $resolved -Recurse -Force
}
