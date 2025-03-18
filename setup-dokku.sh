#!/bin/bash

# Function to prompt for required information
get_user_input() {
    # Prompt for domain
    read -p "Enter your domain (e.g., example.com): " DOMAIN
    while [[ -z "$DOMAIN" ]]; do
        echo "Domain cannot be empty"
        read -p "Enter your domain (e.g., example.com): " DOMAIN
    done

    # Prompt for server IP
    read -p "Enter your server IP: " SERVER_IP
    while [[ -z "$SERVER_IP" ]]; do
        echo "Server IP cannot be empty"
        read -p "Enter your server IP: " SERVER_IP
    done

    # Prompt for Let's Encrypt email
    read -p "Enter email for Let's Encrypt: " LETSENCRYPT_EMAIL
    while [[ -z "$LETSENCRYPT_EMAIL" ]] || ! echo "$LETSENCRYPT_EMAIL" | grep -q '@'; do
        echo "Please enter a valid email address"
        read -p "Enter email for Let's Encrypt: " LETSENCRYPT_EMAIL
    done
}

# Function to install Dokku
install_dokku() {
    echo "Installing Dokku..."
    wget -NP . https://dokku.com/install/v0.35.16/bootstrap.sh
    sudo DOKKU_TAG=v0.35.16 bash bootstrap.sh
}

# Function to setup SSH keys
setup_ssh() {
    echo "Setting up SSH keys..."
    if [ -f ~/.ssh/authorized_keys ]; then
        cat ~/.ssh/authorized_keys | sudo dokku ssh-keys:add admin
    else
        echo "Warning: No authorized_keys file found in ~/.ssh/"
        echo "You'll need to manually add SSH keys later using: dokku ssh-keys:add admin <key>"
    fi
}

# Function to configure domain
configure_domain() {
    echo "Configuring domain..."
    sudo dokku domains:set-global "$DOMAIN"
}

# Function to setup Caddy proxy
setup_caddy() {
    echo "Setting up Caddy proxy..."
    # Switch to Caddy proxy
    sudo dokku proxy:set-global caddy
    
    # Configure Let's Encrypt
    sudo dokku caddy:set --global letsencrypt-email "$LETSENCRYPT_EMAIL"
    
    # Start Caddy
    sudo dokku caddy:start
}

# Main script execution
echo "=== Dokku Setup Script ==="
echo "This script will install Dokku with Caddy as reverse proxy"
echo "Please make sure you have sudo privileges"
echo

# Get user input
get_user_input

# Confirm settings
echo
echo "Please confirm your settings:"
echo "Domain: $DOMAIN"
echo "Server IP: $SERVER_IP"
echo "Let's Encrypt Email: $LETSENCRYPT_EMAIL"
read -p "Continue with these settings? (y/n): " CONFIRM

if [[ "$CONFIRM" != "y" ]]; then
    echo "Setup cancelled"
    exit 1
fi

# Run installation steps
install_dokku
setup_ssh
configure_domain
setup_caddy

echo
echo "=== Installation Complete ==="
echo "Your Dokku installation with Caddy proxy is ready!"
echo "Make sure your domain ($DOMAIN) is pointing to your server IP ($SERVER_IP)"
echo "You can now deploy applications to your Dokku instance"
