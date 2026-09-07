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
    install_xcode_clt
    install_homebrew_and_mas
}

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

install_homebrew_and_mas() {
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

    if command -v mas >/dev/null 2>&1; then
        echo "mas (App Store CLI) is already installed."
    else
        echo "Installing mas..."
        brew install mas
    fi
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

# Function to set up Zsh
setup_zsh() {
    if ! ask_yes_no "Setup Zsh?"; then
        echo "Skipping Zsh setup..."
        return 1
    fi
    echo "Setting up Zsh..."
    brew install starship zsh-autosuggestions zsh-syntax-highlighting zoxide
    create_symlink "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"
    create_symlink "$DOTFILES_DIR/zsh/zshrc.mac" "$DOTFILES_DIR/zsh/zshrc.os"
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
    brew install neovim
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
    brew install --cask wezterm font-jetbrains-mono-nerd-font
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
    brew install --cask zed font-jetbrains-mono-nerd-font
    ensure_config_dir
    mkdir -p "$HOME/.config/zed"
    create_symlink "$DOTFILES_DIR/zed/settings.json" "$HOME/.config/zed/settings.json"
    echo "Zed settings symlinked."
    if [ -f "$DOTFILES_DIR/zed/extensions.txt" ]; then
        echo "Extensions to install (do this manually via Zed's extension manager):"
        cat "$DOTFILES_DIR/zed/extensions.txt"
    fi
}

# Function to install coding tools
setup_coding_tools() {
    if ! ask_yes_no "Install coding tools?"; then
        echo "Skipping coding tools installation..."
        return 1
    fi
    echo "Installing coding tools..."
    # gcc and make installed from xcode-clt
    brew install cmake ninja fnm rustup uv

    # Install default Node.js (LTS)
    fnm install --lts
    fnm default lts-latest

    # rustup is keg-only; add it to PATH for the rest of this script
    export PATH="$(brew --prefix rustup)/bin:$PATH"
    rustup default stable

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
    brew install brave-browser
    mas install 1352778147 # Bitwarden
}

# Function to set up research and knowledge base apps
setup_research_knowledge() {
    if ! ask_yes_no "Setup research and knowledge base apps?"; then
        echo "Skipping research and knowledge base apps setup..."
        return 1
    fi
    echo "Setting up research and knowledge base apps..."
    brew install obsidian zotero
    mas install 360593530 # Notability
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
    echo "Setup complete! Recommended to restart shell"
}

main
