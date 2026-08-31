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

ensure_config_dir() {
    if [ ! -d "$HOME/.config" ]; then
        mkdir "$HOME/.config"
        chmod 700 "$HOME/.config"
    fi
}

# Function to install Homebrew (if not already installed)
install_homebrew() {
    if command -v brew >/dev/null 2>&1; then
        echo "Homebrew already installed."
    else
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add Homebrew to PATH for the rest of this script
        if [[ "$(uname -m)" == "arm64" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    fi
}

# Function to install Xcode Command Line Tools
install_xcode_clt() {
    if xcode-select -p >/dev/null 2>&1; then
        echo "Xcode Command Line Tools already installed."
    else
        echo "Installing Xcode Command Line Tools..."
        xcode-select --install
        # Wait for the user to complete the GUI installation prompt
        echo "Please complete the Xcode CLT installation and press Enter to continue..."
        read -r
    fi
}

# Function to install base packages
install_base_packages() {
    echo "Installing base packages..."
    install_xcode_clt
    install_homebrew
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

# Function to set up git
setup_git() {
    if ! ask_yes_no "Setup Git?"; then
        echo "Skipping Git setup..."
        return 1
    fi
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
    if ! ask_yes_no "Setup SSH?"; then
        echo "Skipping SSH setup..."
        return 1
    fi
    echo "Setting up SSH..."
    # SSH is built-in on macOS; ensure ~/.ssh directory exists with correct permissions
    if [ ! -d "$HOME/.ssh" ]; then
        mkdir "$HOME/.ssh"
        chmod 700 "$HOME/.ssh"
    fi
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
    if ! ask_yes_no "Setup wezterm?"; then
        echo "Skipping wezterm setup..."
        return 1
    fi
    echo "Setting up wezterm..."
    brew install --cask wezterm font-jetbrains-mono-nerd-font
    ensure_config_dir
    ln -sf "$DOTFILES_DIR/wezterm" "$HOME/.config/wezterm"
}

# Function to set up Zed
setup_zed() {
    if ! ask_yes_no "Setup Zed?"; then
        echo "Skipping Zed setup..."
        return 1
    fi
    echo "Setting up Zed..."
    brew install --cask zed font-jetbrains-mono-nerd-font
    ensure_config_dir
    mkdir -p "$HOME/.config/zed"
    ln -sf "$DOTFILES_DIR/zed/settings.json" "$HOME/.config/zed/settings.json"
    echo "Zed settings symlinked."
    if [ -f "$DOTFILES_DIR/zed/extensions.txt" ]; then
        echo "Extensions to install (do this manually via Zed's extension manager):"
        cat "$DOTFILES_DIR/zed/extensions.txt"
    fi
}

# Function to set up Zsh
setup_zsh() {
    if ! ask_yes_no "Setup Zsh?"; then
        echo "Skipping Zsh setup..."
        return 1
    fi
    echo "Setting up Zsh..."
    brew install powerlevel10k zsh-autosuggestions zsh-syntax-highlighting
    ln -sf "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"
    ln -sf "$DOTFILES_DIR/zsh/zshrc.mac" "$DOTFILES_DIR/zsh/zshrc.os"
    ln -sf "$DOTFILES_DIR/zsh/p10k.zsh" "$HOME/.p10k.zsh"
    setup_zshrc_local
}

setup_zshrc_local() {
    local zshrc_local="$DOTFILES_DIR/zsh/zshrc.local"
    if [ ! -f "$zshrc_local" ]; then
        echo "zshrc.local not found."
        echo "Using example zshrc.local file..."
        cp "$DOTFILES_DIR/zsh/zshrc.local.example" "$zshrc_local"
    else
        echo "zshrc.local already exists."
    fi
}

# Function to set up NeoVim
setup_neovim() {
    if ! ask_yes_no "Setup NeoVim?"; then
        echo "Skipping NeoVim setup..."
        return 1
    fi
    echo "Setting up NeoVim..."
    brew install neovim
    ensure_config_dir
    ln -sf "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
}

# Main script
main() {
    echo "Starting setup..."
    install_base_packages
    clone_dotfiles_repo
    setup_git
    setup_ssh
    setup_zsh
    setup_wezterm
    setup_zed
    setup_neovim
    echo "Setup complete! Recommended to restart shell"
}

main
