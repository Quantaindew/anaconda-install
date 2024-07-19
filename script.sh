#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to prompt user for confirmation
confirm() {
    read -r -p "${1:-Are you sure?} [Y/n] " response
    case "$response" in
        [nN][oO]|[nN]) 
            false
            ;;
        *)
            true
            ;;
    esac
}

# Check if script is run with sudo
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo privileges."
    exit 1
fi

# Prompt user before removing existing Anaconda installations
if confirm "This will remove existing Anaconda installations. Continue?"; then
    rm -rf ~/anaconda3 ~/.anaconda /root/anaconda ~/anaconda /root/anaconda3 ~/.anaconda3
else
    echo "Operation cancelled."
    exit 0
fi

# Update package lists
apt-get update

# Install required dependencies
apt-get install -y libgl1-mesa-glx libegl1-mesa libxrandr2 libxss1 libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6 curl

# Download Anaconda installer
ANACONDA_VERSION="Anaconda3-2024.06-1-Linux-x86_64.sh"
DOWNLOAD_URL="https://repo.anaconda.com/archive/$ANACONDA_VERSION"

if ! command_exists curl; then
    apt-get install -y curl
fi

echo "Downloading Anaconda installer..."
curl -O "$DOWNLOAD_URL"

# Verify the integrity of the downloaded file (optional)
# sha256sum $ANACONDA_VERSION

# Install Anaconda
echo "Installing Anaconda..."
bash "$ANACONDA_VERSION" -b -p $HOME/anaconda3

# Activate the changes
source $HOME/.bashrc

# Clean up
rm "$ANACONDA_VERSION"

echo "Anaconda installation completed. Use  anaconda-nagvigator  to start running. Incase of errors, please try restarting your terminal or run   source ~/.bashrc   to use Anaconda."
echo "If that doesn't work please try running the script again."
echo "report any errors as an issue to github.com/Quantaindew/anaconda-install/"

