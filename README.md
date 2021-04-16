# profile

Helps setup my personal profile based on the OS being used. It's designed for
Linux based systems.

## OS-specific Instructions

### linux (ubuntu-flavor)

1. [Setup Github SSH Key](https://help.github.com/en/enterprise/2.15/user/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
2. Run the following commands to run setup
```
# Base dependencies
apt update
apt install curl git tilix

# Get Profile Dir
bash -c "$(curl https://raw.githubusercontent.com/impguard/profile/master/install)"

# Run setup
cd ~/.profile.d
./setup Ubuntu Common
```
3. Startup Tilix (Note: after installation, make sure you change the Tilix
   theme to match nvim)


### windows
1. [Setup Github SSH Key](https://help.github.com/en/enterprise/2.15/user/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
2. May want to setup a Github key for the Windows side as well
3. [Setup WSL 2](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
4. Run the following commands to run setup
```
# Base dependencies
apt update
apt install curl git

# Get Profile
bash -c "$(curl https://raw.githubusercontent.com/impguard/profile/master/install)"

# Run setup
cd ~/.profile.d
./setup Windows Ubuntu Common
```

### osx

1. [Setup Github SSH Key](https://help.github.com/en/enterprise/2.15/user/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
2. Run the following commands to run setup
```
# Base dependencies
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install curl git coreutils

# Setup coreutils temporarily
PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

# Get Profile
bash -c "$(curl https://raw.githubusercontent.com/impguard/profile/master/install)"

# Run setup
cd ~/.profile.d
./setup OSX Common
```

To setup the rest of the computer:

1. Make sure you open `System Preferences > Trackpad` settings and adjust
   accordingly.
2. Make sure you open `System Preferences > Keyboard > Shortcuts` and adjust
   the defaults for ctrl-left, right, up and down. All mission control settings
   should be adjusted to `ctrl-cmd` instead of `ctrl`, and `Application
   Windows` should be disabled.
3. In the same preferences panel, change `Full Keyboard Access` to `All Controls`
4. Change the iTerm2 profile to leverage Solarized with the Minimal theme
5. Once installed, launch hammerspoon and adjust its settings accordingly
