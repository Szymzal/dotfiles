#!/bin/bash

function packages() {
    echo 'Installing packages'
    # Installing essential packages
    sudo pacman -S --needed --noconfirm base-devel git rustup 
    rustup default stable
}

function aurhelper() {
    echo 'Installing AUR-helper (pikaur)'
    # Installing pikaur
    mkdir $HOME/pikaur
    git clone https://aur.archlinux.org/pikaur.git $HOME/pikaur
    pushd $HOME/pikaur
    yes | makepkg -fsri
    popd
    rm -rf $HOME/pikaur
}

function configfiles() {
    echo 'Setting up config files'
    pikaur -S --noconfirm stow
}

function scripts() {
    stow scripts
}

function profile() {
    echo 'Setting up .profile'
    rm -rf $HOME/.profile
    stow profile
}

function fonts() {
    echo 'Installing font for terminal'
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
    fc-cache -f -v
    rm -rf $HOME/firacode
}

function terminalemulator() {
    echo 'Installing and configuring alacritty'
    stow alacritty
    pikaur -S --noconfirm alacritty
}

function shell() {
    echo 'Installing and configuring fish'
    stow fish
    pikaur -S --noconfirm fish
    chsh -s /bin/fish
}

function multitermial() {
    echo 'Installing and configuring tmux'
    stow tmux
    pikaur -S --noconfirm tmux
}

function neovim() {
    echo 'Installing and configuring neovim'
    pikaur -S --noconfirm python3 python-pip xclip
    python3 -m pip install --user --upgrade pynvim
    stow nvim
    pikaur -S --noconfirm neovim
    git clone --depth 1 https://github.com/wbthomason/packer.nvim\
     ~/.local/share/nvim/site/pack/packer/start/packer.nvim
}

function lsps() {
    echo 'Installing LSPs'
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
    pikaur -S zerotier-one
    systemctl enable zerotier-one.service
    systemctl start zerotier-one.service
}

function differentusefulprograms() {
    # Maybe KVM?
    pikaur -S --noconfirm bottles
    pikaur -S --noconfirm jdk17-openjdk jdk8-openjdk polymc-bin
    pikaur -S --noconfirm obs-studio
    pikaur -S --noconfirm wireshark-qt
    pikaur -S --noconfirm gimp
    pikaur -S --noconfirm zoom
    zerotierone
}

function rofi() {
    stow rofi
    pikaur -S --noconfirm rofi
}

function windowmanager() {
    rofi
    stow i3
    pikaur -S --noconfirm i3 nitrogen picom
}

function main() {
    packages
    aurhelper
    configfiles
    scripts
    profile
    fonts
    shell
    terminalemulator
    multitermial
    neovim
    lsps
    differentusefulprograms
    windowmanager
}

main
