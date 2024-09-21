# profile

Helps setup my personal profile based on the OS being used.

## OS-specific Instructions

### linux (ubuntu-flavor)

1. [Setup Github SSH Key](https://help.github.com/en/enterprise/2.15/user/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
2. Run the following commands to run setup

```bash
# Base dependencies
apt update
apt install curl git tilix

# Get Profile Dir
bash -c "$(curl https://raw.githubusercontent.com/impguard/profile/master/install)"

# Run setup
cd ~/.profile.d
./setup install Ubuntu Common
```

3. Startup Tilix (Note: after installation, make sure you change the Tilix
   theme to match nvim)

### windows

#### Install Common Tools

1. Go to https://github.com/microsoft/terminal/releases and pick a release to install
2. Go do https://cloud-images.ubuntu.com/releases/ and select a version to install
3. Look for a file named like
   https://cloud-images.ubuntu.com/releases/jammy/release/ubuntu-22.04-server-cloudimg-amd64-wsl.rootfs.tar.gz
   and download it
4. Run `wsl.exe --import Ubuntu <Install Folder> <.TAR.GZ File Path>`
   - Distribution Name: A friendly name. eg Ubuntu
   - Install folder: a place to put the virtual hard disk, this will not contain human readable files
5. Start the distro and run the following

```
NEW_USER=impguard
adduser "${NEW_USER}"
adduser "${NEW_USER}" sudo
tee /etc/wsl.conf <<_EOF
[user]
default=${NEW_USER}
_EOF
```

6. _Care: this will exit all distros._ Exit the session, then fully shutdown the distro using wsl --shutdown Ubuntu

#### Run Windows setup

1. [Setup Github SSH Key](https://help.github.com/en/enterprise/2.15/user/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
2. Run the following commands to run setup (in powershell)

```powershell
# Install git and Powershell
winget install -e --id gerardog.gsudo
winget install -e --id Microsoft.PowerShell
winget install -e --id Git.Git

# Get Profile (within Powershell, not Windows Powershell)
iex (iwr -UseBasicParsing -URI 'https://raw.githubusercontent.com/impguard/profile/master/install.ps1')

# Run setup (in new Powershell)
cd ~./profile.d
sudo ./setup.ps1 -Install
```

#### Run WSL setup

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
./setup install WSL Ubuntu Common
```

### OSX

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
./setup install OSX Common
```

To setup the rest of the computer:

1. Make sure you open `System Preferences > Trackpad` settings and adjust
   accordingly.
2. Make sure you open `System Preferences > Keyboard > Shortcuts` and adjust
   the defaults for ctrl-left, right, up and down. All mission control settings
   should be adjusted to `ctrl-cmd` instead of `ctrl`, and `Application Windows` should be disabled.
3. In the same preferences panel, change `Full Keyboard Access` to `All Controls`
4. Change the iTerm2 profile to leverage Solarized with the Minimal theme
5. Once installed, launch hammerspoon and adjust its settings accordingly

# TODO

- Need to verify Windows instructions with winget
    - Powertoys
    - Posh Git
    - Zlocation
    - Nanazip
    - Neovim

- Need to install lua by default for tree sitter and neovim
