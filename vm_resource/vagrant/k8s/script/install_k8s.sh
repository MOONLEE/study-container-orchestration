#!/bin/bash


echo "net.ipv4.ip_forward = 1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
echo "IP forwarding has been configured successfully..."

sudo swapoff -a
sudo sed -i '/swap/d' /etc/fstab
echo "Swap is now disabled."


echo "[1/6] Updating system package index..."
sudo apt-get update
if [ $? -ne 0 ]; then
  echo "Error: Failed to update package index."
  exit 1
fi

echo "[2/6] Installing required packages..."
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y apt-transport-https ca-certificates curl
if [ $? -ne 0 ]; then
  echo "Error: Failed to install required packages."
  exit 1
fi

echo "[3/6] Creating keyrings directory if not exists..."
if [ ! -d "/etc/apt/keyrings" ]; then
  sudo mkdir -p /etc/apt/keyrings
fi

echo "[4/6] Downloading Kubernetes GPG key..."
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
if [ $? -ne 0 ]; then
  echo "Error: Failed to download or dearmor the GPG key for Kubernetes repository."
  exit 1
fi

echo "[5/6] Adding Kubernetes repository..."
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

echo "[6/6] Installing Kubernetes components..."
sudo apt-get update
if [ $? -ne 0 ]; then
  echo "Error: Failed to update package index after adding Kubernetes repository."
  exit 1
fi

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y kubelet kubeadm kubectl
if [ $? -ne 0 ]; then
  echo "Error: Failed to install Kubernetes components."
  exit 1
fi

sudo apt-mark hold kubelet kubeadm kubectl

echo "(Optional) Enabling kubelet service..."
sudo systemctl enable --now kubelet
sudo systemctl restart kubelet

echo "Kubernetes installation completed successfully!"
