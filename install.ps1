$name  = Read-Host "Github Name"
$email = Read-Host "Github Email"

git config --global user.name "$name"
git config --global user.email "$email"

git clone git@github.com:impguard/profile-win.git "$HOME\.profile.d"

Write-Output "Please 'cd $HOME\.profile.d' and run the setup manually."
