#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored messages
print_message() {
    echo -e "${BLUE}[Setup] ${NC}$1"
}

print_success() {
    echo -e "${GREEN}[Success] ${NC}$1"
}

print_error() {
    echo -e "${RED}[Error] ${NC}$1"
}

# Check if Bun is installed
if ! command -v bun &> /dev/null; then
    print_error "Bun is not installed. Please install Bun first:"
    print_message "curl -fsSL https://bun.sh/install | bash"
    print_message "Or visit https://bun.sh for other installation methods"
    exit 1
fi

# Install shell-ask globally
print_message "Installing shell-ask globally with Bun..."
bun install -g shell-ask

# Create config directory if it doesn't exist
CONFIG_DIR="$HOME/.config/shell-ask"
mkdir -p "$CONFIG_DIR"

# Prompt for model selection
echo -e "\nAvailable models:"
echo "1) OpenAI (GPT models)"
echo "2) Anthropic Claude"
echo "3) Google Gemini"
echo "4) Groq"

read -p "Select model (1-4): " model_choice

# Initialize config object
config="{}"

case $model_choice in
    1)
        read -p "Enter your OpenAI API key: " api_key
        read -p "Enter your OpenAI API URL (press Enter for default https://api.openai.com/v1): " api_url
        api_url=${api_url:-"https://api.openai.com/v1"}
        config="{\"openai_api_key\": \"$api_key\", \"openai_api_url\": \"$api_url\"}"
        ;;
    2)
        read -p "Enter your Anthropic API key: " api_key
        config="{\"anthropic_api_key\": \"$api_key\"}"
        ;;
    3)
        read -p "Enter your Google API key: " api_key
        read -p "Enter your Google API URL (press Enter for default https://generativelanguage.googleapis.com): " api_url
        api_url=${api_url:-"https://generativelanguage.googleapis.com"}
        config="{\"google_api_key\": \"$api_key\", \"google_api_url\": \"$api_url\"}"
        ;;
    4)
        read -p "Enter your Groq API key: " api_key
        config="{\"groq_api_key\": \"$api_key\"}"
        ;;
    *)
        print_error "Invalid selection"
        exit 1
        ;;
esac

# Save config to file
echo "$config" > "$CONFIG_DIR/config.json"

print_success "shell-ask has been installed and configured!"
print_message "You can now use 'ask' command in your terminal"
print_message "Configuration saved to: $CONFIG_DIR/config.json"
print_message "Documentation: https://github.com/egoist/shell-ask#readme"
