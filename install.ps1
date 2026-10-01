$ErrorActionPreference = 'Stop'
git clone https://github.com/impguard/profile.git "$HOME\.profile.d"
if ($LASTEXITCODE -ne 0) { throw "git clone failed ($LASTEXITCODE)" }

Write-Output "Please 'cd $HOME\.profile.d' and run the setup manually."
