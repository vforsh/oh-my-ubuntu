#!/bin/bash

# Exit on error
set -e

echo "Setting up tealdeer (tldr)..."

# Function to detect current shell
detect_shell() {
    # First try to get from $SHELL environment variable
    if [ -n "$SHELL" ]; then
        local shell_name=$(basename "$SHELL")
        echo "$shell_name"
        return 0
    fi
    
    # If $SHELL is not set, try to detect from process
    if [ -n "$BASH" ]; then
        echo "bash"
        return 0
    elif [ -n "$ZSH_VERSION" ]; then
        echo "zsh"
        return 0
    elif [ -n "$FISH_VERSION" ]; then
        echo "fish"
        return 0
    fi
    
    # If still not detected, check the parent process name
    if ps -p $$ -o comm= 2>/dev/null | grep -q "bash"; then
        echo "bash"
    elif ps -p $$ -o comm= 2>/dev/null | grep -q "zsh"; then
        echo "zsh"
    elif ps -p $$ -o comm= 2>/dev/null | grep -q "fish"; then
        echo "fish"
    else
        echo "unknown"
    fi
}

# Function to install binary release
install_binary() {
    local version="1.7.1"
    local arch=$(uname -m)
    local binary_name=""
    
    case $arch in
        "x86_64")
            binary_name="tealdeer-linux-x86_64-musl"
            ;;
        "aarch64")
            binary_name="tealdeer-linux-arm-musleabihf"
            ;;
        *)
            echo "Architecture $arch not directly supported for binary installation"
            return 1
            ;;
    esac
    
    echo "Downloading tealdeer binary..."
    local url="https://github.com/tealdeer-rs/tealdeer/releases/download/v${version}/${binary_name}"
    
    # Create bin directory if it doesn't exist
    mkdir -p ~/.local/bin
    
    # Download and install binary
    curl -fsSL "$url" -o ~/.local/bin/tldr
    chmod +x ~/.local/bin/tldr
    
    # Add ~/.local/bin to PATH if not already there
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.profile
    fi
    
    echo "Binary installed successfully!"
    return 0
}

# Function to install via cargo
install_via_cargo() {
    if ! command -v cargo &> /dev/null; then
        echo "Cargo not found. Installing Rust and Cargo..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
    fi
    cargo install tealdeer
}

# Install tealdeer
install_tealdeer() {
    # Try binary installation first
    if install_binary; then
        return 0
    fi
    
    echo "Binary installation failed, falling back to cargo installation..."
    install_via_cargo
}

# Setup autocompletions for the current shell
setup_autocompletions() {
    local shell=$(detect_shell)
    local completion_base_url="https://raw.githubusercontent.com/dbrgn/tealdeer/main/completion"
    
    echo "Setting up completions for $shell shell..."
    
    case "$shell" in
        "bash")
            sudo mkdir -p /usr/share/bash-completion/completions
            sudo curl -fsSL "${completion_base_url}/bash_tealdeer" -o /usr/share/bash-completion/completions/tldr
            echo "Bash completions installed. They will be available in new shell sessions."
            ;;
        "fish")
            mkdir -p ~/.config/fish/completions
            curl -fsSL "${completion_base_url}/fish_tealdeer" -o ~/.config/fish/completions/tldr.fish
            echo "Fish completions installed."
            ;;
        "zsh")
            sudo mkdir -p /usr/share/zsh/site-functions
            sudo curl -fsSL "${completion_base_url}/zsh_tealdeer" -o /usr/share/zsh/site-functions/_tldr
            echo "Zsh completions installed. They will be available in new shell sessions."
            ;;
        "unknown"|*)
            echo "Warning: Could not detect shell type. Completions will not be installed."
            echo "Supported shells are: bash, zsh, and fish"
            return 1
            ;;
    esac
    
    echo "Completions installed successfully for $shell!"
}

# Main installation process
main() {
    echo "Installing tealdeer..."
    install_tealdeer
    
    echo "Setting up autocompletions..."
    setup_autocompletions || echo "Skipping completions setup."
    
    echo "Installation complete! You can now use 'tldr' command."
    echo "Please restart your shell or source your shell's config file to enable completions."
}

main
