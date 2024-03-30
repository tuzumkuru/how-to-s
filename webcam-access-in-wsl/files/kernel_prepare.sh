#!/bin/bash

# Step 1: Install Required Packages for Building Kernel
sudo apt update
sudo apt upgrade -y
sudo apt install -y build-essential flex bison libgtk2.0-dev libelf-dev libncurses-dev autoconf libudev-dev libtool zip unzip v4l-utils libssl-dev python3-pip cmake git iputils-ping net-tools dwarves

# Step 2: Download and Configure Custom Kernel
VERSION=$(uname -r | cut -d '-' -f1)
sudo mkdir /usr/src
cd /usr/src
sudo git clone -b linux-msft-wsl-${VERSION} https://github.com/microsoft/WSL2-Linux-Kernel.git ${VERSION}-microsoft-standard
cd ${VERSION}-microsoft-standard
sudo cp /proc/config.gz config.gz
sudo gunzip config.gz
sudo mv config .config

# Step 3: Modify Kernel Configuration
# In the menuconfig interface, navigate to the following options:
# Device Drivers -> Multimedia support -> Filter media drivers
# Device Drivers -> Multimedia support -> Media device types -> Cameras and video grabbers
# Device Drivers -> Multimedia support -> Video4Linux options -> V4L2 sub-device userspace API
# Device Drivers -> Multimedia support -> Media drivers -> Media USB Adapters -> USB Video Class (UVC)
# Device Drivers -> Multimedia support -> Media drivers -> Media USB Adapters -> UVC input events device support
# Device Drivers -> Multimedia support -> Media drivers -> Media USB Adapters -> GSPCA based webcams
sudo make menuconfig

# Step 4: Build Custom Kernel
sudo make -j$(nproc)
sudo make modules_install -j$(nproc)
sudo make install -j$(nproc)

# Step 5: Install Custom Kernel to Windows User Folder
mkdir -p /mnt/c/Users/$(whoami)/kernel/
sudo cp -rf vmlinux /mnt/c/Users/$(whoami)/kernel/

echo "Custom kernel image has been copied to /mnt/c/Users/$(whoami)/kernel/."

# Step 6: Configure WSL to Use Custom Kernel
echo "[wsl2]" > /mnt/c/Users/$(whoami)/.wslconfig
echo "kernel=C:\\Users\\$(whoami)\\kernel\\vmlinux" | sed 's/\\/\\\\/g' >> /mnt/c/Users/$(whoami)/.wslconfig
