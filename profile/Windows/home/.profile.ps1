# Optional modules are loaded only when installed.
if (Get-Module -ListAvailable posh-git) {
  Import-Module posh-git
  $GitPromptSettings.EnableFileStatus = $false
  $GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $true
}
if (Get-Module -ListAvailable ZLocation) {
  Import-Module ZLocation
  Set-Alias -Name j Invoke-ZLocation
}
if (Get-Module -ListAvailable PSReadLine) {
  Import-Module PSReadLine
  Set-PSReadLineOption -EditMode Emacs
  Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
}
if (Get-Command nvim -ErrorAction SilentlyContinue) { $env:EDITOR = 'nvim' }
Set-Alias -Name open -Value Start-Process
if (Get-Command mise -ErrorAction SilentlyContinue) {
  mise activate pwsh | Out-String | Invoke-Expression
}
# Machine-specific settings belong outside this repository.
$localProfile = Join-Path $HOME '.profile.local.ps1'
if (Test-Path -LiteralPath $localProfile) { . $localProfile }
