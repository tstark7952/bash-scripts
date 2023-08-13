#!/bin/bash

# Install jq if needed
if ! [ -x "$(command -v jq)" ]; then
  sudo apt install jq
fi

# Get latest stable version 
version=$(curl -s https://www.kernel.org/releases.json | jq -r '.latest_stable."version"')

# Make build directories
mkdir linux-latest
cd linux-latest

# Download kernel source
wget "https://cdn.kernel.org/pub/linux/kernel/v${version%%.*}.x/linux-$version.tar.xz"

# Extract source 
tar xvf linux-$version.tar.xz

# Enter source directory
cd linux-$version

# Install build dependencies
sudo apt-get update
sudo apt-get install build-essential libncurses-dev bison flex libssl-dev libelf-dev

# Configure kernel
make defconfig

# Build kernel 
make -j $(nproc)

# Install modules and firmware
sudo make modules_install install

# Update grub 
sudo update-grub

# Reboot system
sudo reboot