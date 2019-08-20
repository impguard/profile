# profile

Helps setup my personal profile based on the OS being used. It's designed for
Linux based systems.

## Pre-Installation

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
brew install curl git
```

## Installation

Run the following command to setup the local environment
```
bash -c "$(curl https://raw.githubusercontent.com/impguard/profile/master/install.sh)"
```
