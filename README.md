# profile

Helps setup my personal profile based on the OS being used. It's designed for
Linux based systems.

## OS-specific Instructions

### linux (ubuntu-flavor)

1. [Setup Github SSH Key](https://help.github.com/en/enterprise/2.15/user/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
2. Run the following commands to run preinstallation
```
apt upgrade
apt install curl git tilix
```
3. Startup Tilix (Note: after installation, make sure you change the Tilix to
   match nvim)

### osx

1. [Setup Github SSH Key](https://help.github.com/en/enterprise/2.15/user/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
2. Run the following commands to install brew and additional utilities
```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install curl git coreutils
```
3. Note that before the installation, you will have to temporarily add coreutils to your PATH
```
PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
```
4. Make sure you open `System Preferences > Trackpad` settings and adjust
   accordingly.
5. Make sure you open `System Preferences > Keyboard > Shortcuts` and adjust
   the defaults for ctrl-left, right, up and down. All mission control settings
   should be adjusted to `ctrl-cmd` instead of `ctrl`, and `Application
   Windows` should be disabled.
6. In the same preferences panel, change `Full Keyboard Access` to `All Controls`
7. Change the iTerm2 profile to leverage Solarized with the Minimal theme
8. Once installed, launch hammerspoon and adjust its settings accordingly

## Installation

Run the following command to setup the local environment
```
bash -c "$(curl https://raw.githubusercontent.com/impguard/profile/master/install.sh)"
```
