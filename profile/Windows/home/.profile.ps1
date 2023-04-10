# Import Modules
Import-Module posh-git
Import-Module ZLocation

# Prompt Customization
$GitPromptSettings.EnableFileStatus = $false
$GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $true
$GitPromptSettings.DefaultPromptPath.ForegroundColor = 'Orange'
$GitPromptSettings.DefaultPromptPrefix.Text = '`n'
$GitPromptSettings.DefaultPromptBeforeSuffix.Text = '`n'
$GitPromptSettings.DefaultPromptSuffix.Text = "$([char]0x276F)  "
$GitPromptSettings.DefaultPromptSuffix.ForegroundColor = 'Orange'
 
# Set Readline to Emacs Mode
Set-PSReadLineOption -EditMode Emacs
# Set Tab Completion to operate like Bash
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Aliases
Set-Alias -Name open Start-Process
Set-Alias -Name j Invoke-ZLocation
