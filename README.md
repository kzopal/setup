# setup

This is a bash script to debloat and install my preferred software on a fresh install of Ubuntu 24.04.04 LTS.

It uses the ubuntu-debullshit script as a baseline to clean up the operating system.

What this script does:

1. Removes all snaps and blocks them from coming back.

2. Sets up flathub for flatpak applications.

3. Restores firefox as a regular package instead of a snap.

4. Updates the system packages.

5. Installs the i3 window manager and tools like htop and fastfetch.

6. Installs development tools and the JetBrains Mono font.

7. Clones and compiles the st terminal from github.

8. Replaces the gdm3 display manager with lightdm to save resources.

How to use it:

Open your terminal on a fresh Ubuntu install and run:

    sudo bash -c "$(wget -qO- https://raw.githubusercontent.com/kzopal/setup/main/run.sh)"

This command will automatically download run.sh, which pulls down the required ubuntu-debullshit.sh and main.sh scripts, makes them executable, and starts the installation.

After the script finishes, reboot your computer so the changes take effect and you can log into i3.

Warning: This script makes big changes to the system like removing gdm3 and snaps. It is tailored for my personal preferences, so use it at your own risk.
