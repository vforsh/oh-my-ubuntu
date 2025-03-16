#!/bin/bash

# Oh My Ubuntu - An opinionated script to set up Ubuntu for a delightful dev experience
# This script installs: git, bun, bat (with cat alias), fzf, eza (with ls alias), starship prompt, and zoxide

set -e  # Exit immediately if a command exits with a non-zero status

# Print colored output
print_message() {
    echo -e "\e[1;34m>> $1\e[0m"
}

# Check if running as root
# if [ "$EUID" -eq 0 ]; then
    # echo "Please do not run this script as root or with sudo."
    # exit 1
# fi

print_message "Updating package lists..."
sudo apt update

print_message "Installing Git..."
sudo apt install -y git

# Set up Git completions
print_message "Setting up Git completions..."
if ! grep -q "source /usr/share/bash-completion/completions/git" ~/.bashrc; then
    # Install bash-completion if not already installed
    sudo apt install -y bash-completion
    
    # Add Git completion to bashrc
    echo "# Git completions" >> ~/.bashrc
    echo "if [ -f /usr/share/bash-completion/completions/git ]; then" >> ~/.bashrc
    echo "    source /usr/share/bash-completion/completions/git" >> ~/.bashrc
    echo "fi" >> ~/.bashrc
    
    print_message "Added Git completions to ~/.bashrc"
fi

print_message "Installing Bat (a better cat)..."
sudo apt install -y bat
# Create alias for bat -> cat
if ! grep -q "alias cat='batcat'" ~/.bashrc; then
    echo "alias cat='batcat'" >> ~/.bashrc
    print_message "Added 'cat' alias for 'batcat' in ~/.bashrc"
fi

print_message "Installing fzf (fuzzy finder)..."
# Install fzf from Git repository
if [ ! -d ~/.fzf ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all --no-bash --no-fish --key-bindings --completion --update-rc
    print_message "Installed fzf from Git repository"
else
    print_message "fzf is already installed, updating..."
    cd ~/.fzf && git pull && ./install --all --no-bash --no-fish --key-bindings --completion --update-rc
fi

# Ensure fzf initialization is in .bashrc
if ! grep -q "source ~/.fzf.bash" ~/.bashrc; then
    echo "# fzf setup" >> ~/.bashrc
    echo "[ -f ~/.fzf.bash ] && source ~/.fzf.bash" >> ~/.bashrc
    print_message "Added fzf initialization to ~/.bashrc"
fi

print_message "Installing eza (a modern ls replacement)..."
# Install dependencies
sudo apt install -y curl gpg

# Add eza repository
if [ ! -f /etc/apt/sources.list.d/gierens.list ]; then
    print_message "Adding eza repository..."
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt update
fi

# Install eza
sudo apt install -y eza

# Create alias for eza -> ls
if ! grep -q "alias ls='eza'" ~/.bashrc; then
    echo "# eza aliases" >> ~/.bashrc
    echo "alias ls='eza'" >> ~/.bashrc
    echo "alias ll='eza -l'" >> ~/.bashrc
    echo "alias la='eza -la'" >> ~/.bashrc
    echo "alias lt='eza --tree'" >> ~/.bashrc
    print_message "Added 'ls', 'll', 'la', and 'lt' aliases for 'eza' in ~/.bashrc"
fi

print_message "Installing zoxide (a smarter cd command)..."
# Install dependencies
sudo apt install -y curl

# Ensure ~/.local/bin is in PATH
if ! grep -q 'PATH="$HOME/.local/bin:$PATH"' ~/.bashrc; then
    echo "# Add ~/.local/bin to PATH" >> ~/.bashrc
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    print_message "Added ~/.local/bin to PATH in ~/.bashrc"
    # Also add to current session
    export PATH="$HOME/.local/bin:$PATH"
fi

# Install zoxide for the current user (not as root)
if ! command -v zoxide &> /dev/null; then
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    print_message "Installed zoxide"
fi

# Configure zoxide for bash
if ! grep -q "eval \"\$(zoxide init bash)\"" ~/.bashrc; then
    echo "# zoxide setup" >> ~/.bashrc
    echo 'eval "$(zoxide init bash)"' >> ~/.bashrc
    print_message "Added zoxide initialization to ~/.bashrc"
fi

# Add utility aliases for bashrc management
print_message "Adding utility aliases for bashrc management..."
if ! grep -q "alias ebc=" ~/.bashrc; then
    echo "# Utility aliases" >> ~/.bashrc
    echo "alias ebc='nano ~/.bashrc'" >> ~/.bashrc
    echo "alias sbc='source ~/.bashrc'" >> ~/.bashrc
    print_message "Added 'ebc' (edit bashrc) and 'sbc' (source bashrc) aliases"
fi

print_message "Installing Starship prompt..."
# Install dependencies
sudo apt install -y curl

# Install Starship
if ! command -v starship &> /dev/null; then
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
    print_message "Installed Starship prompt"
fi

# Configure Starship for bash
if ! grep -q "eval \"\$(starship init bash)\"" ~/.bashrc; then
    echo "# Starship prompt" >> ~/.bashrc
    echo 'eval "$(starship init bash)"' >> ~/.bashrc
    print_message "Added Starship initialization to ~/.bashrc"
fi

# Create default Starship config if it doesn't exist
if [ ! -f ~/.config/starship.toml ]; then
    mkdir -p ~/.config
    cat > ~/.config/starship.toml << 'EOF'
# Starship Configuration

# Don't print a new line at the start of the prompt
add_newline = false

# Make prompt a single line instead of two lines
[line_break]
disabled = false

# Replace the "❯" symbol with "→"
[character]
success_symbol = "[→](bold green)"
error_symbol = "[→](bold red)"

# Disable the package module, hiding it from the prompt completely
[package]
disabled = true

# Display Git branch and status
[git_branch]
format = "[$symbol$branch]($style) "
style = "bold purple"

[git_status]
format = '([\[$all_status$ahead_behind\]]($style) )'
style = "bold yellow"

# Show command duration
[cmd_duration]
min_time = 500
format = "took [$duration](bold yellow)"
EOF
    print_message "Created default Starship configuration at ~/.config/starship.toml"
fi

print_message "Installing Bun..."
# Install unzip if not already installed (required for Bun installation)
sudo apt install -y unzip curl
curl -fsSL https://bun.sh/install | bash

# Set up Bun completions
print_message "Setting up Bun completions..."
# Add Bun to PATH temporarily for this script
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Create bash completion directory if it doesn't exist
mkdir -p ~/.bash_completion.d

# Generate Bun completions and save to file
$HOME/.bun/bin/bun completions > ~/.bash_completion.d/bun.bash
print_message "Generated Bun completions at ~/.bash_completion.d/bun.bash"

# Source Bun completions in bashrc if not already there
if ! grep -q "source ~/.bash_completion.d/bun.bash" ~/.bashrc; then
    echo "# Bun completions" >> ~/.bashrc
    echo "source ~/.bash_completion.d/bun.bash" >> ~/.bashrc
    print_message "Added Bun completions to ~/.bashrc"
fi

# Add Bun to PATH if not already added
if ! grep -q 'export BUN_INSTALL="$HOME/.bun"' ~/.bashrc; then
    echo "# Bun PATH" >> ~/.bashrc
    echo 'export BUN_INSTALL="$HOME/.bun"' >> ~/.bashrc
    echo 'export PATH="$BUN_INSTALL/bin:$PATH"' >> ~/.bashrc
    print_message "Added Bun to PATH in ~/.bashrc"
fi

print_message "Installation complete! 🎉"
print_message "To use the new tools, either restart your terminal or run: source ~/.bashrc"

# Display installed versions
print_message "Installed versions:"
echo "Git: $(git --version 2>/dev/null || echo 'Not installed')"
echo "Bat: $(batcat --version 2>/dev/null || echo 'Not installed')"
echo "fzf: $(fzf --version 2>/dev/null || echo 'Not installed')"
echo "eza: $(eza --version 2>/dev/null || echo 'Not installed')"
echo "zoxide: $(zoxide --version 2>/dev/null || echo 'Not installed')"
echo "Starship: $(starship --version 2>/dev/null || echo 'Not installed')"
echo "Bun: $(~/.bun/bin/bun --version 2>/dev/null || echo 'Not installed')" 