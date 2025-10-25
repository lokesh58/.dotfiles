#!/bin/bash

# Constants
DOTFILES_REPO="git@github.com:lokesh58/.dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"

# Utilities
ask_yes_no() {
    local prompt="$1"
    local response

    while true; do
        read -p "$prompt [y/n]: " response
        case "$response" in
        [Yy]*) return 0 ;; # Yes
        [Nn]*) return 1 ;; # No
        *) echo "Please answer y or n." ;;
        esac
    done
}

# Function to install base packages
install_base_packages() {
    echo "Installing base packages..."
    sudo pacman -S --noconfirm --needed git
}

# Function to clone the dotfiles repository
clone_dotfiles_repo() {
    if [ ! -d "$DOTFILES_DIR" ]; then
        echo "Dotfiles repository not found. Cloning..."
        git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
        chmod 700 "$DOTFILES_DIR"
    else
        echo "Dotfiles repository already exists at $DOTFILES_DIR."
    fi
}

# Function to set up bash
setup_bash() {
    if ! ask_yes_no "Setup Bash?"; then
        echo "Skipping Bash setup..."
        return 1
    fi
    echo "Setting up Bash..."
    ln -sf "$DOTFILES_DIR/bash/bashrc" "$HOME/.bashrc"
    chmod 600 "$HOME/.bashrc"
    setup_bashrc_local
}

setup_bashrc_local() {
    local bashrc_local="$DOTFILES_DIR/bash/bashrc.local"
    if [ ! -f "$bashrc_local" ]; then
        echo "bashrc.local not found."
        echo "Using example bashrc.local file..."
        cp "$DOTFILES_DIR/bash/bashrc.local.example" "$bashrc_local"
    else
        echo "bashrc.local already exists."
    fi
}

# Function to set up git
setup_git() {
    if ! ask_yes_no "Setup Git?"; then
        echo "Skipping Git setup..."
        return 1
    fi
    echo "Setting up Git..."
    ln -sf "$DOTFILES_DIR/git/gitconfig" "$HOME/.gitconfig"
    chmod 600 "$HOME/.gitconfig"
    setup_gitconfig_local
}

setup_gitconfig_local() {
    local gitconfig_local="$DOTFILES_DIR/git/gitconfig.local"
    if [ ! -f "$gitconfig_local" ]; then
        echo "gitconfig.local not found."
        echo "Using example gitconfig.local file..."
        cp "$DOTFILES_DIR/git/gitconfig.local.example" "$gitconfig_local"
    else
        echo "gitconfig.local already exists."
    fi
}

# Function to set up ssh
setup_ssh() {
    if ! ask_yes_no "Setup SSH?"; then
        echo "Skipping SSH setup..."
        return 1
    fi
    echo "Setting up SSH..."
    sudo pacman -S --noconfirm --needed openssh
    ln -sf "$DOTFILES_DIR/ssh/config" "$HOME/.ssh/config"
    chmod 600 "$HOME/.ssh/config"
    setup_ssh_config_local
}

setup_ssh_config_local() {
    local ssh_config_local="$DOTFILES_DIR/ssh/config.local"
    if [ ! -f "$ssh_config_local" ]; then
        echo "ssh/config.local not found."
        echo "Using example ssh/config.local file..."
        cp "$DOTFILES_DIR/ssh/config.local.example" "$ssh_config_local"
    else
        echo "ssh/config.local already exists."
    fi
}

# Function to set up wezterm
setup_wezterm() {
    if ! ask_yes_no "Setup wezterm?"; then
        echo "Skipping wezterm setup..."
        return 1
    fi
    echo "Setting up wezterm..."
    sudo pacman -S --noconfirm --needed wezterm ttf-meslo-nerd
    if [ ! -d "$HOME/.config" ]; then
        mkdir "$HOME/.config"
        chmod 700 "$HOME/.config"
    fi
    ln -sf "$DOTFILES_DIR/wezterm" "$HOME/.config"
}

# Function to set up NeoVim
setup_neovim() {
    if ! ask_yes_no "Setup NeoVim?"; then
        echo "Skipping NeoVim setup..."
        return 1
    fi
    echo "Setting up NeoVim..."
    sudo pacman -S --noconfirm --needed neovim lazygit imagemagick make unzip fd ripgrep ast-grep gcc python gemini-cli
    if [ ! -d "$HOME/.config" ]; then
        mkdir "$HOME/.config"
        chmod 700 "$HOME/.config"
    fi
    ln -sf "$DOTFILES_DIR/nvim" "$HOME/.config"

    # setup node as needed by neovim
    if ! command -v node >/dev/null 2>&1; then
        setup_node
    fi

    # setup rust as needed by neovim
    if ! command -v rustc >/dev/null 2>&1; then
        setup_rust
    fi
}

setup_node() {
    echo "Setting up node via nvm..."
    sudo pacman -S --noconfirm --needed nvm
    source /usr/share/nvm/init-nvm.sh
    nvm install --lts
    nvm alias default node
    nvm use default
}

setup_rust() {
    echo "Setting up rust via rustup..."
    sudo pacman -S --noconfirm --needed rustup
    rustup default stable
}

# Function to set up MangoHud
setup_mangohud() {
    if ! ask_yes_no "Setup MangoHud?"; then
        echo "Skipping MangoHud setup..."
        return 1
    fi
    echo "Setting up MangoHud..."
    if [ ! -d "$HOME/.config" ]; then
        mkdir "$HOME/.config"
        chmod 700 "$HOME/.config"
    fi
    ln -sf "$DOTFILES_DIR/MangoHud" "$HOME/.config"
}

# Function to set up clangd
setup_clangd() {
    if ! ask_yes_no "Setup clangd?"; then
        echo "Skipping clangd setup..."
        return 1
    fi
    echo "Setting up clangd..."
    if [ ! -d "$HOME/.config" ]; then
        mkdir "$HOME/.config"
        chmod 700 "$HOME/.config"
    fi
    ln -sf "$DOTFILES_DIR/clangd" "$HOME/.config"
}

# Main script
main() {
    echo "Starting setup..."
    install_base_packages
    clone_dotfiles_repo
    setup_bash
    setup_git
    setup_ssh
    setup_wezterm
    setup_neovim
    setup_mangohud
    setup_clangd
    echo "Setup complete! Recommended to restart shell"
}

main
