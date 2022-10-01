#!/bin/bash

function packages() {
    # Installing essential packages
    pikaur -S --noconfirm rustup stow zsh tmux \
        python3 python-pip neovim \
        tree \
        curl wget openssl \
        nvm vscode-langservers-extracted lua-language-server fzf rust-analyzer

    sudo npm install -g typescript-language-server typescript bash-language-server

    rustup default stable
    cargo install tauri-cli
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
    setup_config "zsh"
    setup_config "tmux"
    setup_config "nvim"
}

function addition_apps() {
    $HOME/.scripts/update
}

function shell() {
    chsh -s /bin/zsh
}

function neovim() {
    python3 -m pip install --user --upgrade pynvim
    nvim --headless -c 'autocmd User PackerComplete quitall'
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

                if [[ -f "$HOMEPATH" ]]; do
                    rm -d $HOME_PATH
                fi
            done
        fi
    done
    stow $CONFIG
}

function main() {
    aurhelper
    packages
    config_files
    addition_apps
    shell
    neovim

    echo "Installator finished! You would need to restart computer to work everything properly."
}

main
