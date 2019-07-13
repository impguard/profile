# profile

Helps setup my personal profile based on the OS being used. It's designed for
Linux based systems.

## Pre-Installation

### Lubuntu

1. [Setup Github SSH Key](https://help.github.com/en/enterprise/2.15/user/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
2. Run the following commands to run lubuntu preinstallation
```
apt upgrade
apt install curl
sudo bash -c "$(curl https://raw.githubusercontent.com/impguard/profile/master/pre-installation/lubuntu.sh)"
```
