#!/bin/bash

function packages() {
    # Installing essential packages
    pikaur -S --noconfirm rustup stow alacritty fish tmux \
        python3 python-pip xclip neovim \
        zerotier-one bottles jdk17-openjdk jdk8-openjdk polymc-bin obs-studio wireshark-qt gimp zoom lxsession-gtk3 \
        archlinux-keyring qemu virt-manager virt-viewer dnsmasq bridge-utils libguestfs \
        rofi i3-gaps polybar nitrogen picom
}

function aurhelper() {
    sudo pacman -S --needed --noconfirm base-devel git
    # Installing pikaur
    mkdir $HOME/pikaur
    git clone https://aur.archlinux.org/pikaur.git $HOME/pikaur
    pushd $HOME/pikaur
    makepkg -fsri --noconfirm
    popd
    rm -rf $HOME/pikaur
}

function scripts() {
    stow scripts
}

function profile() {
    rm -rf $HOME/.profile
    stow profile
}

function fonts() {
    # FiraCode
    mkdir $HOME/firacode
    pushd $HOME/firacode
    curl -s https://api.github.com/repos/tonsky/FiraCode/releases/latest \
    | grep "Fira_Code_v.*zip" \
    | cut -d : -f 2,3 \
    | tr -d \" \
    | wget -qi -
    unzip *.zip -d extracted
    popd
    pushd $HOME/firacode/extracted/ttf
    sudo mv *.ttf /usr/share/fonts/TTF/
    popd
    rm -rf $HOME/firacode
    # Material icons
    mkdir $HOME/material-icons
    pushd $HOME/material-icons
    wget https://github.com/google/material-design-icons/raw/master/font/MaterialIcons-Regular.ttf
    sudo mv MaterialIcons-Regular.ttf /usr/share/fonts/TTF/
    popd
    rm -rf $HOME/material-icons

    fc-cache -f -v
}

function terminalemulator() {
    stow alacritty
}

function shell() {
    stow fish
    chsh -s /bin/fish
}

function multitermial() {
    stow tmux
}

function neovim() {
    python3 -m pip install --user --upgrade pynvim
    stow nvim
    git clone --depth 1 https://github.com/wbthomason/packer.nvim\
     ~/.local/share/nvim/site/pack/packer/start/packer.nvim
}

function lsps() {
    rustup default stable
    # rust-analyzer
    mkdir $HOME/rust-analyzer
    pushd $HOME/rust-analyzer
    curl -s https://api.github.com/repos/rust-lang/rust-analyzer/releases/latest \
    | grep "rust-analyzer-x86_64-unknown-linux-gnu.gz" \
    | cut -d : -f 2,3 \
    | tr -d \" \
    | wget -qi -
    gzip -d rust-analyzer-x86_64-unknown-linux-gnu.gz
    mkdir $HOME/.local/bin
    mv rust-analyzer-x86_64-unknown-linux-gnu $HOME/.local/bin/rust-analyzer
    popd
    rm -rf $HOME/rust-analyzer
    chmod +x $HOME/.local/bin/rust-analyzer
}

function zerotierone() {
    sudo systemctl enable zerotier-one.service
    sudo systemctl start zerotier-one.service
}

function windowmanager() {
    stow rofi
    stow polybar
    stow i3
}

function main() {
    aurhelper
    packages
    scripts
    profile
    fonts
    shell
    terminalemulator
    multitermial
    neovim
    lsps
    zerotierone
    windowmanager
    reboot
}

main
