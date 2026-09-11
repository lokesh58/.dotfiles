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

create_symlink() {
    local src="$1"
    local dest="$2"

    if [ -L "$dest" ]; then
        if [ "$(readlink "$dest")" = "$src" ]; then
            echo "Symlink already exists and is correct: $dest"
            return 0
        else
            echo "Removing incorrect symlink: $dest"
            rm "$dest"
        fi
    elif [ -e "$dest" ]; then
        local timestamp=$(date +%Y%m%d_%H%M%S)
        echo "Backing up existing file/directory: $dest to $dest.bak.$timestamp"
        mv "$dest" "$dest.bak.$timestamp"
    fi

    echo "Creating symlink: $dest -> $src"
    ln -s "$src" "$dest"
}

# Function to install base packages
install_base_packages() {
    echo "Installing base packages..."
    sudo pacman -S --noconfirm --needed git base-devel rustup
    rustup default stable

    if ! command -v paru >/dev/null 2>&1; then
        echo "Installing paru..."
        local temp_dir
        temp_dir=$(mktemp -d)
        (
            cd "$temp_dir" || exit 1
            git clone https://aur.archlinux.org/paru.git
            cd paru
            makepkg -si --noconfirm
        )
        rm -rf "$temp_dir"
    else
        echo "paru already installed."
    fi
}

# Function to clone the dotfiles repository
clone_dotfiles_repo() {
    if [ ! -d "$DOTFILES_DIR" ]; then
        echo "Dotfiles repository not found. Cloning..."
        git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
    else
        echo "Dotfiles repository already exists at $DOTFILES_DIR."
    fi
    chmod 700 "$DOTFILES_DIR"
}

# Function to set up Zsh
setup_zsh() {
    if ! ask_yes_no "Setup Zsh?"; then
        echo "Skipping Zsh setup..."
        return 1
    fi
    echo "Setting up Zsh..."

    # Install zsh and essential plugins/theme
    sudo pacman -S --noconfirm --needed zsh zsh-autosuggestions zsh-syntax-highlighting starship zoxide

    create_symlink "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"
    create_symlink "$DOTFILES_DIR/zsh/zshrc.arch" "$DOTFILES_DIR/zsh/zshrc.os"

    setup_zshrc_local

    # Optional: Change default shell to zsh
    if [ "$SHELL" != "$(which zsh)" ]; then
        echo "Changing default shell to zsh (this may prompt for your password):"
        chsh -s "$(which zsh)" || echo "Failed to change shell. You can run 'chsh -s \$(which zsh)' manually later."
    fi
}

setup_zshrc_local() {
    local zshrc_local="$DOTFILES_DIR/zsh/zshrc.local"
    if [ ! -f "$zshrc_local" ]; then
        echo "zshrc.local not found."
        echo "Using example zshrc.local file..."
        cp "$DOTFILES_DIR/zsh/zshrc.local.example" "$zshrc_local" 2>/dev/null || true
    else
        echo "zshrc.local already exists."
    fi
}

# Function to set up git
setup_git() {
    if ! ask_yes_no "Setup Git?"; then
        echo "Skipping Git setup..."
        return 1
    fi
    echo "Setting up Git..."
    create_symlink "$DOTFILES_DIR/git/gitconfig" "$HOME/.gitconfig"
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
    if [ ! -d "$HOME/.ssh" ]; then
        mkdir "$HOME/.ssh"
        chmod 700 "$HOME/.ssh"
    fi
    create_symlink "$DOTFILES_DIR/ssh/config" "$HOME/.ssh/config"
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

# Function to set up NeoVim
setup_neovim() {
    if ! ask_yes_no "Setup NeoVim?"; then
        echo "Skipping NeoVim setup..."
        return 1
    fi
    echo "Setting up NeoVim..."
    sudo pacman -S --noconfirm --needed neovim
    ensure_config_dir
    create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
}

# Function to set up wezterm
setup_wezterm() {
    if ! ask_yes_no "Setup wezterm?"; then
        echo "Skipping wezterm setup..."
        return 1
    fi
    echo "Setting up wezterm..."
    sudo pacman -S --noconfirm --needed wezterm ttf-jetbrains-mono-nerd
    ensure_config_dir
    create_symlink "$DOTFILES_DIR/wezterm" "$HOME/.config/wezterm"
}

# Function to set up Zed
setup_zed() {
    if ! ask_yes_no "Setup Zed?"; then
        echo "Skipping Zed setup..."
        return 1
    fi
    echo "Setting up Zed..."
    sudo pacman -S --noconfirm --needed zed ttf-jetbrains-mono-nerd
    ensure_config_dir
    mkdir -p "$HOME/.config/zed"
    create_symlink "$DOTFILES_DIR/zed/settings.json" "$HOME/.config/zed/settings.json"
    echo "Zed settings symlinked."
    if [ -f "$DOTFILES_DIR/zed/extensions.txt" ]; then
        echo "Extensions to install (do this manually via Zed's extension manager):"
        cat "$DOTFILES_DIR/zed/extensions.txt"
    fi
}

# Function to set up coding tools
setup_coding_tools() {
    if ! ask_yes_no "Setup coding tools?"; then
        echo "Skipping coding tools setup..."
        return 1
    fi
    echo "Setting up coding tools..."
    # rustup installed in base packages
    sudo pacman -S --noconfirm --needed gcc cmake make ninja fnm uv

    # Install default Node.js (LTS)
    fnm install --lts
    fnm default lts-latest

    # Install default Python
    uv python install --default
}

# Function to set up essential utility apps
setup_essential_utility() {
    if ! ask_yes_no "Setup essential utility apps?"; then
        echo "Skipping essential utility apps setup..."
        return 1
    fi
    echo "Setting up essential utility apps..."
    sudo pacman -S --noconfirm --needed bitwarden
    paru -S --needed brave-bin
}

# Function to set up research and knowledge base apps
setup_research_knowledge() {
    if ! ask_yes_no "Setup research and knowledge base apps?"; then
        echo "Skipping research and knowledge base apps setup..."
        return 1
    fi
    echo "Setting up research and knowledge base apps..."
    sudo pacman -S --noconfirm --needed obsidian
    paru -S --needed zotero-bin
}

# Function to set up llama.cpp server
setup_llama_server() {
    if ! ask_yes_no "Setup llama.cpp server?"; then
        echo "Skipping llama.cpp server setup..."
        return 1
    fi
    echo "Setting up llama.cpp server..."
    # TODO: See if ggml-cuda can be made generic by offering a choice
    sudo pacman -S --noconfirm --needed llama-cpp ggml-cuda

    ensure_config_dir
    mkdir -p $HOME/local-llms/gguf # folder where server will look for models
    mkdir -p $HOME/.config/systemd/user
    cp "$DOTFILES_DIR/llama-cpp/llama-server.service" "$HOME/.config/systemd/user/llama-server.service"
    systemctl --user daemon-reload
    systemctl --user enable --now llama-server.service
}

# Function to set up gaming
setup_gaming() {
    if ! ask_yes_no "Setup gaming?"; then
        echo "Skipping gaming setup..."
        return 1
    fi
    echo "Setting up gaming..."

    sudo pacman -S --noconfirm --needed steam mangohud lib32-mangohud gamemode lib32-gamemode

    sudo usermod -aG gamemode "$USER"

    ensure_config_dir
    create_symlink "$DOTFILES_DIR/MangoHud" "$HOME/.config/MangoHud"
}

# Main script
main() {
    echo "Starting setup..."
    install_base_packages
    clone_dotfiles_repo
    setup_zsh
    setup_git
    setup_ssh
    setup_neovim
    setup_wezterm
    setup_zed
    setup_coding_tools
    setup_essential_utility
    setup_research_knowledge
    setup_llama_server
    setup_gaming
    echo "Setup complete! Recommended to restart shell"
}

main
