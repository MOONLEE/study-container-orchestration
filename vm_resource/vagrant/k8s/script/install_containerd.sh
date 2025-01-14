#!/bin/bash

set -e

export DEBIAN_FRONTEND=noninteractive

echo "Step 1: Updating system packages..."
sudo apt-get update -y

echo "Step 2: Installing prerequisites..."
sudo apt-get install -y  ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings

echo "Step 3: Adding Docker GPG key..."
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc



echo "Step 4: Adding Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null


echo "Step 5: Updating package index..."
sudo apt-get update -y

echo "Step 6: Installing containerd.io..."
sudo apt-get install -y containerd.io

if [ $? -ne 0 ]; then
  echo "Error: Unable to install containerd.io. Please check the repository and network connectivity."
  exit 1
fi

echo "Step 7: Configuring containerd..."
# configuration change
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml


sudo systemctl start containerd
sudo systemctl enable containerd
sudo systemctl restart containerd
echo "containerd installation completed successfully!"

