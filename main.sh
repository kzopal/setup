#!/usr/bin/env bash

source utils.sh

setup_display_manager() {
    echo "lightdm shared/default-x-display-manager select lightdm" | sudo debconf-set-selections

    sudo DEBIAN_FRONTEND=noninteractive apt install lightdm slick-greeter numlockx -y
    #uncomment next line if somthing breaks
    #echo -e "[Seat:*]\ngreeter-session=slick-greeter" | sudo tee /etc/lightdm/lightdm.conf

    sudo systemctl enable lightdm
}

install_packages() {
    sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch

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
}

build_st() {
    cd /tmp
    if [ -d "st" ]; then rm -rf st; fi
    git clone https://github.com/kzopal/st.git
    cd st

    make
    sudo make clean install

    sudo update-alternatives --remove-all x-terminal-emulator
    sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/local/bin/st 50

    cd ~
}

cleanup_desktop() {
    sudo apt purge gdm3 -y || true

    sudo apt remove ubuntu-session yaru-theme-gnome-shell yaru-theme-gtk yaru-theme-icon yaru-theme-sound -y
    sudo apt remove gnome-* -y
    sudo apt autoremove -y
}

main() {
    msg "Stripping Ubuntu bloat..."
    remove_appcrash_popup
    disable_terminal_ads
    disable_ubuntu_report
    remove_snaps

    msg "Configuring system and browser..."
    update_system
    setup_flathub
    restore_firefox
    configure_firefox
    setup_bashrc

    msg "Installing core packages and i3..."
    setup_display_manager
    install_packages

    msg "Building st terminal and removing GNOME..."
    build_st
    cleanup_desktop

    msg "Setup complete!"
    ask_reboot
}

main
