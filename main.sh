#!/usr/bin/env bash

source ubuntu-debullshit.sh

remove_snaps
update_system
setup_flathub
restore_firefox

echo "lightdm shared/default-x-display-manager select lightdm" | sudo debconf-set-selections

#add fastfetch ppa
sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch

#Install the build dependencies, JetBrains Mono font, and git
sudo apt update
sudo apt install -y \
    build-essential \
    git \
    libx11-dev \
    libxft-dev \
    libxext-dev \
    pkg-config \
    fonts-jetbrains-mono \
    i3 \
    htop \
    fastfetch

#install lightdm non interactively
sudo DEBIAN_FRONTEND=noninteractive apt install lightdm lightdm-gtk-greeter -y

#st section

#clone kzopal/st to a temporary directory
cd /tmp
# Clear out any old 'st' folder from previous script runs so git clone doesn't fail
if [ -d "st" ]; then rm -rf st; fi
git clone https://github.com/kzopal/st.git
cd st

#compile and install
make
sudo make clean install
cd ~

#do this before removing all the gdm stuff
sudo systemctl enable lightdm

#wipe gdm3
sudo apt purge gdm3 -y || true
sudo apt autoremove -y

echo "Done. Reboot if necessary"
