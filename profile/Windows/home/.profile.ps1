# Posh Git
Import-Module posh-git

# Prompt Customization
$GitPromptSettings.DefaultPromptPath.ForegroundColor = 'Orange'
$GitPromptSettings.EnableFileStatus = $false
$GitPromptSettings.DefaultPromptBeforeSuffix.Text = ' '
$GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $true

# Set Readline to Emacs Mode
Set-PSReadLineOption -EditMode Emacs
# Set Tab Completion to operate like Bash
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Aliases
Set-Alias -Name open Start-Process
Set-Alias -Name j Invoke-ZLocation