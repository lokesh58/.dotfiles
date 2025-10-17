#!/bin/bash

# Constants
DOTFILES_REPO="git@github.com:lokesh58/.dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"

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
    else
        echo "Dotfiles repository already exists at $DOTFILES_DIR."
    fi
}

# Function to set up bash
setup_bash() {
    echo "Setting up Bash..."
    ln -sf "$DOTFILES_DIR/bash/bashrc" "$HOME/.bashrc"
    setup_bashrc_local
}

setup_bashrc_local() {
    local bashrc_local="$DOTFILES_DIR/bash/bashrc.local"
    if [ ! -f "$bashrc_local" ]; then
        echo "bashrc.local not found."
        echo "Using example bashrc.local file..."
        cp "$DOTFILES_DIR/git/bashrc.local.example" "$bashrc_local"
    else
        echo "bashrc.local already exists."
    fi
}

# Function to set up git
setup_git() {
    echo "Setting up Git..."
    ln -sf "$DOTFILES_DIR/git/gitconfig" "$HOME/.gitconfig"
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
    echo "Setting up SSH..."
    sudo pacman -S --noconfirm --needed openssh
    ln -sf "$DOTFILES_DIR/ssh/config" "$HOME/.ssh/config"
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
    echo "Setting up wezterm..."
    sudo pacman -S --noconfirm --needed wezterm ttf-meslo-nerd
    if [ ! -d "$HOME/.config" ]; then
        mkdir "$HOME/.config"
    fi
    ln -sf "$DOTFILES_DIR/wezterm" "$HOME/.config"
}

# Function to set up NeoVim
setup_neovim() {
    echo "Setting up NeoVim..."
    sudo pacman -S --noconfirm --needed neovim lazygit imagemagick make unzip fd ripgrep ast-grep
    if [ ! -d "$HOME/.config" ]; then
        mkdir "$HOME/.config"
    fi
    ln -sf "$DOTFILES_DIR/nvim" "$HOME/.config"
}

# Function to set up MangoHud
setup_mangohud() {
    echo "Setting up MangoHud..."
    if [ ! -d "$HOME/.config" ]; then
        mkdir "$HOME/.config"
    fi
    ln -sf "$DOTFILES_DIR/MangoHud" "$HOME/.config"
}

# Function to set up clangd
setup_clangd() {
    echo "Setting up clangd..."
    if [ ! -d "$HOME/.config" ]; then
        mkdir "$HOME/.config"
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
    echo "Setup complete!"
}

main
