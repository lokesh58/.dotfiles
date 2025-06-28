#!/bin/bash

# Constants
DOTFILES_REPO="git@github.com:lokesh58/.dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"

# Function to install base packages
install_base_packages() {
    echo "Installing base packages..."
    sudo pacman -Syu --needed git
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
        read -p "Do you want to set it up interactively? (y/n): " choice
        if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
            echo "Setting up gitconfig.local interactively..."
            read -p "Enter your Git username: " git_user_name
            read -p "Enter your Git display name: " git_name
            read -p "Enter your Git email: " git_email
            cat > "$gitconfig_local" <<EOF
[user]
  email = $git_email
  name = $git_name
  user = $git_user_name
EOF
        else
            echo "Using example gitconfig.local file..."
            cp "$DOTFILES_DIR/git/gitconfig.local.example" "$gitconfig_local"
        fi
    else
        echo "gitconfig.local already exists."
    fi
}

# Main script
main() {
    echo "Starting setup..."
    install_base_packages
    clone_dotfiles_repo
    setup_git
    echo "Setup complete!"
}

main
