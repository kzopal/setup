#!/usr/bin/env bash

source ubuntu-debullshit.sh

remove_appcrash_popup
disable_terminal_ads
disable_ubuntu_report
remove_snaps
update_system
setup_flathub
restore_firefox

echo "lightdm shared/default-x-display-manager select lightdm" | sudo debconf-set-selections

#install lightdm non interactively
sudo DEBIAN_FRONTEND=noninteractive apt install lightdm slick-greeter numlockx -y
#uncomment next line if somthing breaks
#echo -e "[Seat:*]\ngreeter-session=slick-greeter" | sudo tee /etc/lightdm/lightdm.conf

#do this before removing all the gdm stuff
sudo systemctl enable lightdm

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

#wipe gdm3 and old desktop
sudo apt purge gdm3 -y || true

sudo apt remove ubuntu-session yaru-theme-gnome-shell yaru-theme-gtk yaru-theme-icon yaru-theme-sound -y

sudo apt autoremove -y

echo "Done. Reboot if necessary"
