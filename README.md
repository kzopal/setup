# setup

> [!CAUTION]
> This script makes significant changes to the system and is tailored for my
> personal preferences and is designed to run on a fresh install of Ubuntu 24.04. Use it at your own risk.

A heavily modified fork of
[ubuntu-debullshit](https://github.com/polkaulfield/ubuntu-debullshit) that strips a fresh Ubuntu install down and sets up a minimal, efficent
environment built around i3 and [kzopal/st](https://github.com/kzopal/st).

## What it does

1. Removes all snaps and blocks them permanently
2. Sets up Flathub for Flatpak
3. Restores Firefox as a native .deb
4. Updates all system packages
5. Installs i3, htop, fastfetch, and supporting tools
6. Installs dev tools and JetBrains Mono
7. Clones and compiles [kzopal/st](https://github.com/kzopal/st) from source
8. Replaces GDM3 with LightDM
9. Configures Firefox with arkenfox user.js, uBlock Origin, dark mode, and Tokyo Night theme
10. Installs a custom .bashrc with a styled prompt

## Structure

```
setup/
├── run.sh       # Downloads and launches everything
├── deploy.sh    # Main deployment controller
└── utils.sh     # All debloating and config functions
```

## Usage

On a fresh Ubuntu 24.04 install:

```bash
sudo bash -c "$(wget -qO- kzopal.github.io/setup/run.sh)"
```

run.sh downloads utils.sh and deploy.sh, makes them executable, and
starts the installation. Reboot when it's done to apply all changes and log
into i3.
