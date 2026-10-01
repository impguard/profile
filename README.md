# profile

A small development environment for Ubuntu/WSL, macOS, and Windows. The default setup installs Git, curl, Neovim, and **mise** alongside Bash or PowerShell. Language runtimes, compiler libraries, terminal extras, and desktop apps are opt-in.

## What gets installed

| Environment | Default tools | Configuration |
| --- | --- | --- |
| Ubuntu / WSL | Bash, Git, curl, CA certificates, mise, Neovim | Bash, Git defaults, Neovim Lua config |
| macOS (`OSX`) | Homebrew Bash, Git, curl, Neovim, mise | Bash login shell, Git defaults, Neovim Lua config |
| Windows | Git, Neovim, mise via winget | PowerShell, Git defaults, Neovim Lua config |

Windows uses the built-in curl and requires PowerShell 7. macOS requires Homebrew. Ubuntu uses the official Neovim **v0.12.5** build (x86_64 or ARM64), installed under `~/.local/opt` with a launcher in `~/.local/bin`; no PPA is added. Set `NVIM_VERSION=vX.Y.Z` when running setup to select a different release. Homebrew and winget use their available releases; Windows setup skips tools already on PATH.

Mise is installed, but **no language runtimes are installed automatically**. No Neovim plugins, Python providers, tmux plugins, or employer-specific settings are required.

## Ubuntu and WSL

For a new WSL installation, run this from an **administrator PowerShell** terminal:

```powershell
wsl --install -d Ubuntu
```

Restart if requested, launch Ubuntu, and complete its username/password setup. An existing WSL installation can use `wsl --list --online` and `wsl --install -d <name>` to add another distribution. See [Microsoft's WSL instructions](https://learn.microsoft.com/windows/wsl/install).

Inside Ubuntu (Ubuntu 22.04 or newer):

```bash
sudo apt-get update
sudo apt-get install --no-install-recommends -y ca-certificates curl git
git clone https://github.com/impguard/profile.git ~/.profile.d
cd ~/.profile.d

# Inspect what will run; no changes are made by plan.
bash ./setup plan WSL Ubuntu Common
bash ./setup install WSL Ubuntu Common
```

On native Ubuntu, omit `WSL`:

```bash
bash ./setup install Ubuntu Common
```

Open a new terminal after installation. Keep Linux projects under `~/code` for WSL filesystem performance. The WSL profile adds `open` for Explorer when available; it uses Linux Git and does not copy files into your Windows home.

## Windows

Install [App Installer / winget](https://learn.microsoft.com/windows/package-manager/winget/) if it is not already available. In PowerShell:

```powershell
winget install --exact --id Microsoft.PowerShell --source winget
winget install --exact --id Git.Git --source winget
```

Open **PowerShell 7** (`pwsh`) so the updated PATH is loaded:

```powershell
git clone https://github.com/impguard/profile.git "$HOME\.profile.d"
Set-Location "$HOME\.profile.d"
./setup.ps1 -Plan
./setup.ps1 -Install
```

Setup does not require gsudo or symbolic-link privileges. Winget may request elevation for individual packages. If your execution policy blocks local scripts, use `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` if allowed by your machine's policy. Reopen PowerShell after installation so Git, Neovim, and mise are on PATH.

The profile is installed at `$PROFILE.CurrentUserCurrentHost` (the usual `$PROFILE`), and Neovim uses `%LOCALAPPDATA%\nvim\init.lua`. Existing profiles for other PowerShell hosts remain untouched. Personal additions can go in `~/.profile.local.ps1`.

Windows and WSL have separate mise installations, runtimes, and home configurations. Run each setup in its own environment.

## macOS

Install [Homebrew](https://brew.sh), including the Command Line Tools it requests. Then:

```bash
brew install git curl
git clone https://github.com/impguard/profile.git ~/.profile.d
cd ~/.profile.d
bash ./setup plan OSX Common
bash ./setup install OSX Common
```

This repository configures **Bash**, not macOS's default Zsh. Configure your terminal to launch `/opt/homebrew/bin/bash -l` on Apple Silicon or `/usr/local/bin/bash -l` on Intel. The login profile loads Homebrew and `.bashrc`; changing your account's default shell is not required.

## Optional profiles

Append only the profiles you need to the install command, or install them later. For example:

```bash
bash ./setup install WSL Ubuntu Common Terminal WSLClipboard
# Later, install only compiler dependencies:
bash ./setup install BuildTools
```

| Profile / switch | Adds |
| --- | --- |
| `Terminal` (Ubuntu/macOS) | tmux, Screen, fzf, ripgrep, autojump, ShellCheck, Bash completion; tmux and Screen configs |
| `BuildTools` (Ubuntu/macOS) | Compiler / Python source-build libraries; macOS uses Command Line Tools supplied with Homebrew |
| `WSLClipboard` | win32yank v0.1.1 for Neovim clipboard sharing; x86_64 WSL only; installs unzip if missing |
| `DotNet` | OmniSharp formatting settings in the current Linux/macOS home only; no SDK or Windows copy |
| `Tilix` (Ubuntu) | Tilix terminal and Gruvbox theme |
| `MacDesktop` | Hammerspoon and its window-management configuration |
| Windows `-Extras` | Current-user posh-git and ZLocation PowerShell modules |

```powershell
./setup.ps1 -Install -Extras
```

Optional package installs can add dependencies through their package manager. Setup never removes previously installed tools or runtimes.

## Languages with mise

Bash and PowerShell activate mise when it is installed. Choose your own global defaults:

```text
mise use --global node@lts
mise use --global python@latest
mise use --global go@latest
mise use --global java@lts
mise ls
```

For a project, run `mise use node@22 python@3.13` in its directory to write a `mise.toml`. Commit that file to share version requirements. For an existing project's configuration, review it, run `mise trust` if requested, then `mise install`. `mise exec -- <command>` also works in scripts without interactive shell activation. See [mise documentation](https://mise.jdx.dev/getting-started.html).

Use `python -m venv .venv` for Python virtual environments. No `en` or `pvenv` helper is needed. The old pyenv, nodenv, goenv, jenv, and NVM initialization is removed; existing manager directories and installed runtimes are left intact. Review your own `.bashrc.d`, PowerShell overrides, and project version files during migration. Install `BuildTools` if a runtime needs to compile from source.

## Neovim

The shared config is now `profile/Common/home/.config/nvim/init.lua`, using Neovim's Lua API and modern built-in defaults. It provides two-space indentation, case-aware search, sensible splits, persistent undo, clipboard integration when a provider exists, and a few mappings:

| Mapping | Action |
| --- | --- |
| `,e` | Browse files with built-in netrw |
| `,w` / `,q` | Save / close window |
| `,d` | Show the current diagnostic |
| `Esc` | Clear search highlighting |

Start with `:Tutor`, `:checkhealth`, and `:help nvim-defaults`. The old Vim-Plug config, Tokyo Night theme, tree/search plugins, automatic whitespace removal, and local-directory config loading are gone. There is no plugin bootstrap step. Neovim's built-in LSP, diagnostics, and completion are available; language servers and their configuration remain opt-in. On Neovim 0.11+, use `vim.lsp.config()` and `vim.lsp.enable()` when adding a language. A future plugin setup can build on this file without being needed for startup today.

Personal additions can live in `lua/local_config.lua` inside the Neovim config directory. Desktop Linux clipboard support needs an appropriate provider such as `wl-clipboard` or `xclip`; WSL can use `WSLClipboard`. The old `init.vim` is backed up when installing `init.lua`, since Neovim cannot load both as its primary config.

## Backups, updates, and local settings

- Home configs are **copies**, not links into this repository. Updating the checkout does not immediately alter your active configuration.
- Changed destination files are backed up under `~/.profile-backups/<run>/` before replacement. Unchanged files are skipped. The printed backup location is the place to recover prior settings.
- Git defaults are installed as `~/.config/git/profile.gitconfig` and included at the beginning of `~/.gitconfig`. Existing identity, credentials, and settings stay in that file and override the defaults. No name/email is hardcoded. On a new machine, run `git config --global user.name "Your Name"` and `git config --global user.email "you@example.com"`.
- Bash sources readable files in `~/.source/`, then `~/.bashrc.d/`. Put private or machine-specific overrides in the latter. Git's prompt helper is loaded when available; it is optional.
- Rerunning setup reapplies repository configs, so keep local edits in the documented override files or review your backup afterward. It does not remove unrelated home files or uninstall tools.
- The obsolete `~/.source/enable.sh` and Neovim `init.vim` are backed up and retired during migration. Old plugin downloads and language-manager directories are left in place.
- Windows refuses directory symlinks at config destinations instead of writing through them. Replace those directory links with real directories before running setup; individual file links from the old installer are migrated to copies.

To update, pull this repository and rerun the relevant setup command. Ubuntu's Neovim version is pinned above; mise runtimes update only when you ask mise to update them. Setup stops on the first failed script and reports its path. A failure can leave earlier steps installed; fix it and rerun. Bash script workspaces are retained on failure for inspection. There is no automatic rollback of package-manager changes.

Useful commands:

```bash
bash ./setup ls
bash ./setup plan Ubuntu Common
bash ./setup home Common        # configuration only
bash ./setup pre Ubuntu         # package prerequisites only
bash ./setup script path/to/script.sh
bash tests/setup.sh             # isolated installer regression tests
```

```powershell
./setup.ps1 -CopyHome           # configuration only
./setup.ps1 -Init               # tools only
./tests/setup.ps1               # isolated Windows regression tests
```
