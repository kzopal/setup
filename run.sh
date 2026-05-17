#!/usr/bin/env bash

# Stop the script if any error happens
set -e

# Download the ubuntu-debullshit script
echo "Downloading utils.sh..."
wget -qO ubuntu-debullshit.sh https://raw.githubusercontent.com/kzopal/setup/refs/heads/main/utils.sh

# Download your main setup script
echo "Downloading main.sh..."
wget -qO main.sh https://raw.githubusercontent.com/kzopal/setup/refs/heads/main/main.sh

# Make both scripts executable
chmod +x utils.sh main.sh

# Run your main setup script
echo "Starting the setup..."
./main.sh
