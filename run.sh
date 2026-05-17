#!/usr/bin/env bash

# Stop the script if any error happens
set -e

# Download the ubuntu-debullshit script
echo "Downloading ubuntu-debullshit.sh..."
wget -qO ubuntu-debullshit.sh https://raw.githubusercontent.com/kzopal/setup/refs/heads/main/ubuntu-debullshit.sh

# Download your main setup script
echo "Downloading main.sh..."
wget -qO main.sh https://raw.githubusercontent.com/kzopal/setup/refs/heads/main/main.sh

# Make both scripts executable
chmod +x ubuntu-debullshit.sh main.sh

# Run your main setup script
echo "Starting the setup..."
./main.sh
