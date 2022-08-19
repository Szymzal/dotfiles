#!/bin/bash

function packages() {
    # Installing essential packages
    pikaur -S --noconfirm rustup stow alacritty fish tmux \
        python3 python-pip xclip neovim \
        zerotier-one bottles jdk17-openjdk jdk8-openjdk polymc-bin obs-studio wireshark-qt gimp zoom lxsession-gtk3 \
        steam tree \
        rofi i3-gaps polybar nitrogen picom \
        webkit2gtk curl wget openssl appmenu-gtk-module gtk3 libappindicator-gtk3 librsvg libvips \
        nodejs npm vscode-langservers-extracted lua-language-server
	    #archlinux-keyring qemu virt-manager virt-viewer dnsmasq bridge-utils libguestfs \

    sudo npm install -g typescript-language-server typescript @volar/vue-language-server bash-language-server
}

function aurhelper() {
    sudo pacman -Syu --needed --noconfirm base-devel git
    # Installing pikaur
    mkdir $HOME/pikaur
    git clone https://aur.archlinux.org/pikaur.git $HOME/pikaur
    pushd $HOME/pikaur
    makepkg -fsri --noconfirm
    popd
    rm -rf $HOME/pikaur
}

function config_files() {
    setup_config "scripts"
    setup_config "profile"
    setup_config "alacritty"
    setup_config "fish"
    setup_config "tmux"
    setup_config "nvim"
    setup_config "rofi"
    setup_config "polybar"
    setup_config "i3"
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

function shell() {
    chsh -s /bin/fish
}

function neovim() {
    python3 -m pip install --user --upgrade pynvim
    nvim --headless -c 'autocmd User PackerComplete quitall'
}

function lsps() {
    # rust-analyzer
    rustup default stable
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
    cargo install tauri-cli
}

function services() {
    sudo systemctl enable zerotier-one.service
    sudo systemctl start zerotier-one.service
}

function setup_config() {
    INSTALLER_PATH=$(dirname "$0")
    CONFIG="$1"
    CONFIG_PATH="$INSTALLER_PATH/$CONFIG"
    for f in $(find $CONFIG_PATH -type f)
    do
        HOME_PATH=${f/$CONFIG_PATH/$HOME}
        if [[ -f "$HOME_PATH" ]]; then

            TEST_DIRECTORY_HOME_PATH="$HOME/"
            while [[ ${TEST_DIRECTORY_HOME_PATH%/} != "$HOME_PATH" ]]; do 
                UNCHECKED_DIRS=${HOME_PATH#"$TEST_DIRECTORY_HOME_PATH"}
                UNCHECKED_DIR=${UNCHECKED_DIRS%/*}
                TEST_DIRECTORY_HOME_PATH="$TEST_DIRECTORY_HOME_PATH$UNCHECKED_DIR/"
                
                if [[ -L ${TEST_DIRECTORY_HOME_PATH%/} ]]; then
                    rm ${TEST_DIRECTORY_HOME_PATH%/}
                    break
                fi
            done

            if [[ -f "$HOME_PATH" ]]; then
                rm $HOME_PATH
            fi

            while ! [[ "$(ls -A $(dirname "$HOME_PATH"))" ]]; do
                HOME_PATH=$(dirname "$HOME_PATH")
                rm -d $HOME_PATH
            done
        fi
    done
    stow $CONFIG
}

function main() {
    aurhelper
    packages
    config_files
    shell
    fonts
    services
    neovim
    lsps
    #reboot
}

main
