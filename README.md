# setup

This is a bash script to debloat and install my preferred software on a fresh install of Ubuntu 24.04.04 LTS.

It uses the ubuntu-debullshit script as a baseline to clean up the operating system.

What this script does:

Removes all snaps and blocks them from coming back.

Sets up flathub for flatpak applications.

Restores firefox as a regular package instead of a snap.

Updates the system packages.

Installs the i3 window manager and tools like htop and fastfetch.

Installs development tools and the JetBrains Mono font.

Clones and compiles the st terminal from github.

Replaces the gdm3 display manager with lightdm to save resources.

How to use it:

You do not need to download anything manually. Open your terminal on a fresh Ubuntu install and run this single command:

sudo bash -c "$(wget -qO- https://raw.githubusercontent.com/kzopal/setup/main/run.sh)"

This command will automatically download run.sh, which pulls down the required ubuntu-debullshit.sh and main.sh scripts, makes them executable, and starts the installation.

After the script finishes, reboot your computer so the changes take effect and you can log into i3.

Warning: This script makes big changes to the system like removing gdm3 and snaps. It is tailored for my personal preferences, so use it at your own risk.
