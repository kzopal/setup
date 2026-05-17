#!/usr/bin/env bash

disable_ubuntu_report() {
    ubuntu-report send no
    apt remove ubuntu-report -y
}

remove_appcrash_popup() {
    apt remove apport apport-gtk -y
}

remove_snaps() {
    while [ "$(snap list | wc -l)" -gt 0 ]; do
        for snap in $(snap list | tail -n +2 | cut -d ' ' -f 1); do
            snap remove --purge "$snap" 2> /dev/null
        done
    done

    systemctl stop snapd
    systemctl disable snapd
    systemctl mask snapd
    apt purge snapd -y
    rm -rf /snap /var/lib/snapd
    for userpath in /home/*; do
        rm -rf $userpath/snap
    done
    cat <<-EOF | tee /etc/apt/preferences.d/nosnap.pref
	Package: snapd
	Pin: release a=*
	Pin-Priority: -10
	EOF
}

disable_terminal_ads() {
    sed -i 's/ENABLED=1/ENABLED=0/g' /etc/default/motd-news 2>/dev/null
    pro config set apt_news=false
}

update_system() {
    apt update && apt upgrade -y
}

cleanup() {
    apt autoremove -y
}

setup_flathub() {
    apt install flatpak -y
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    apt install --install-suggests gnome-software -y
}

gsettings_wrapper() {
    if ! command -v dbus-launch; then
        sudo apt install dbus-x11 -y
    fi
    sudo -Hu $(logname) dbus-launch gsettings "$@"
}

set_fonts() {
	gsettings_wrapper set org.gnome.desktop.interface monospace-font-name "Monospace 10"
}


install_adwgtk3() {    
    wget -O /tmp/adw-gtk3.tar.xz https://github.com/lassekongo83/adw-gtk3/releases/download/v5.10/adw-gtk3v5.10.tar.xz
    tar -xf /tmp/adw-gtk3.tar.xz -C /usr/share/themes/
    if command -v flatpak; then
        flatpak install -y runtime/org.gtk.Gtk3theme.adw-gtk3-dark
        flatpak install -y runtime/org.gtk.Gtk3theme.adw-gtk3
    fi
    if [ "$(gsettings_wrapper get org.gnome.desktop.interface color-scheme | tail -n 1)" == ''\''prefer-dark'\''' ]; then
        gsettings_wrapper set org.gnome.desktop.interface gtk-theme adw-gtk3-dark
        gsettings_wrapper set org.gnome.desktop.interface color-scheme prefer-dark
    else
        gsettings_wrapper set org.gnome.desktop.interface gtk-theme adw-gtk3
    fi
}

install_icons() {
    apt install adwaita-icon-theme -y
    apt install git -y
    git clone https://github.com/somepaulo/MoreWaita.git /tmp/MoreWaita
    /tmp/MoreWaita/install.sh
    apt install adwaita-icon-theme -y
    gsettings_wrapper set org.gnome.desktop.interface icon-theme MoreWaita
    gsettings_wrapper set org.gnome.desktop.interface accent-color blue
}

restore_firefox() {
    wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- > /etc/apt/keyrings/packages.mozilla.org.asc
    echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" > /etc/apt/sources.list.d/mozilla.list 
    echo '
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
' > /etc/apt/preferences.d/mozilla
    apt update
    apt install firefox -y
}

configure_firefox() {
    local real_user real_home firefox_dir

    real_user="${SUDO_USER:-$(logname 2>/dev/null || echo "$USER")}"
    real_home="$(eval echo "~$real_user")"

    msg "Setting up Firefox distribution policies..."
    mkdir -p /usr/lib/firefox/distribution

    cat > /usr/lib/firefox/distribution/policies.json << 'POLICIES_EOF'
{
  "policies": {
    "ExtensionSettings": {
      "uBlock0@raymondhill.net": {
        "installation_mode": "force_installed",
        "install_url": "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi"
      }
    },
    "Extensions": {
      "Install": [
        "https://addons.mozilla.org/firefox/downloads/latest/tokyo-night-milav/latest.xpi"
      ]
    }
  }
}
POLICIES_EOF

    msg "Setting Firefox dark mode preferences..."
    mkdir -p /etc/firefox
    cat > /etc/firefox/syspref.js << 'SYSPREF_EOF'
pref("ui.systemUsesDarkTheme", 1);
SYSPREF_EOF

    msg "Downloading arkenfox user.js..."
    firefox_dir="$real_home/.mozilla/firefox"
    mkdir -p "$firefox_dir"

    local profiles_ini="$firefox_dir/profiles.ini"
    local profile_path=""

    if [ -f "$profiles_ini" ]; then
        profile_path=$(grep -E "^Path=" "$profiles_ini" | head -1 | cut -d= -f2)
    fi

    if [ -z "$profile_path" ]; then
        profile_path="default-release"
        mkdir -p "$firefox_dir/$profile_path"
        cat > "$profiles_ini" << PROFILES_EOF
[General]
StartWithLastProfile=1

[Profile0]
Name=default
IsRelative=1
Path=$profile_path
Default=yes
PROFILES_EOF
    fi

    wget -qO "$firefox_dir/$profile_path/user.js" https://raw.githubusercontent.com/arkenfox/user.js/master/user.js
    chown -R "$real_user:$real_user" "$firefox_dir" 2>/dev/null || true

    msg "Firefox configured with arkenfox user.js, uBlock Origin, and Tokyo Night theme."
}

setup_bashrc() {
    local real_user real_home

    real_user="${SUDO_USER:-$(logname 2>/dev/null || echo "$USER")}"
    real_home="$(eval echo "~$real_user")"

    msg "Setting up custom .bashrc..."

    [ -f "$real_home/.bashrc" ] && cp "$real_home/.bashrc" "$real_home/.bashrc.bak"

    cat > "$real_home/.bashrc" << 'BASHRC_EOF'
# ~/.bashrc

[ -z "$PS1" ] && return

HISTCONTROL=ignoreboth
shopt -s histappend
shopt -s checkwinsize

alias ls='ls --color'
LS_COLORS='di=1;35:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rpm=90:*.png=35:*.gif=36:*.jpg=35:*.c=92:*.jar=33:*.py=93:*.h=90:*.txt=94:*.doc=104:*.docx=104:*.odt=104:*.csv=102:*.xlsx=102:*.xlsm=102:*.rb=31:*.cpp=92:*.sh=92:*.html=96:*.zip=4;33:*.tar.gz=4;33:*.mp4=105:*.mp3=106'
export LS_COLORS HISTSIZE= HISTFILESIZE=

export PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]\u\[$(tput setaf 2)\]@\[$(tput setaf 4)\]\h \[$(tput setaf 5)\]\W\[$(tput setaf 1)\]]\[$(tput setaf 7)\]\\$ \[$(tput sgr0)\]"

stty -ixon
BASHRC_EOF

    chown "$real_user:$real_user" "$real_home/.bashrc" "$real_home/.bashrc.bak" 2>/dev/null || true

    msg "Custom .bashrc installed."
}

ask_reboot() {
    echo 'Reboot now? (y/n)'
    while true; do
        read choice
        if [[ "$choice" == 'y' || "$choice" == 'Y' ]]; then
            reboot
            exit 0
        fi
        if [[ "$choice" == 'n' || "$choice" == 'N' ]]; then
            break
        fi
    done
}

msg() {
    tput setaf 2
    echo "[*] $1"
    tput sgr0
}

error_msg() {
    tput setaf 1
    echo "[!] $1"
    tput sgr0
}

check_root_user() {
    if [ "$(id -u)" != 0 ]; then
        echo 'Please run the script as root!'
        echo 'We need to do administrative tasks'
        exit
    fi
}

enable_appindicator() {
    gsettings_wrapper set org.gnome.shell enabled-extensions "['ubuntu-appindicators@ubuntu.com']"
}
